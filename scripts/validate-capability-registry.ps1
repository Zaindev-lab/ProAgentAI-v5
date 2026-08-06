param(
    [string]$RepositoryRoot = ".",
    [string]$RegistryPath = "docs/capabilities/Capability_Registry.md",
    [string]$CapabilitiesRoot = "docs/capabilities"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Capability Registry Check"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$root = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$registryFile = Join-Path $root $RegistryPath
$capabilitiesDirectory = Join-Path $root $CapabilitiesRoot

if (-not (Test-Path -LiteralPath $registryFile -PathType Leaf)) {
    Write-Host "[ERROR] Capability Registry not found: $registryFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path -LiteralPath $capabilitiesDirectory -PathType Container)) {
    Write-Host "[ERROR] Capabilities directory not found: $capabilitiesDirectory" -ForegroundColor Red
    exit 1
}

$errors = 0
$warnings = 0
$registeredIds = @{}
$registeredPaths = @{}

function Normalize-MarkdownText {
    param([string]$Text)

    return (
        $Text `
            -replace '\\+', '' `
            -replace '\*', '' `
            -replace '`', ''
    ).Trim()
}

function Get-DocumentMetadata {
    param([string]$FilePath)

    $metadata = @{
        DocumentId = $null
        Category   = $null
        Version    = $null
        Status     = $null
        Owner      = $null
    }

    $lines = Get-Content -LiteralPath $FilePath -Encoding utf8 |
        Select-Object -First 80

    foreach ($line in $lines) {
        $normalized = Normalize-MarkdownText -Text $line

        if ($normalized -match '^Document ID:\s*(?<value>\S+)\s*$') {
            $metadata.DocumentId = $Matches["value"].Trim()
        }
        elseif ($normalized -match '^Category:\s*(?<value>.+?)\s*$') {
            $metadata.Category = $Matches["value"].Trim()
        }
        elseif ($normalized -match '^Version:\s*(?<value>\S+)\s*$') {
            $metadata.Version = $Matches["value"].Trim()
        }
        elseif ($normalized -match '^Status:\s*(?<value>.+?)\s*$') {
            $metadata.Status = $Matches["value"].Trim()
        }
        elseif ($normalized -match '^Owner:\s*(?<value>.+?)\s*$') {
            $metadata.Owner = $Matches["value"].Trim()
        }
    }

    return $metadata
}

$registryLines = Get-Content -LiteralPath $registryFile -Encoding utf8

foreach ($line in $registryLines) {
    if ($line -notmatch '^\s*\|\s*CAP-\d{3,}\s*\|') {
        continue
    }

    $columns = @(
        $line.Trim().Trim('|').Split('|') |
        ForEach-Object { $_.Trim() }
    )

    if ($columns.Count -lt 7) {
        Write-Host "[ERROR] Invalid registry row:" -ForegroundColor Red
        Write-Host "        $line"
        $errors++
        continue
    }

    $capabilityId = $columns[0]
    $name = $columns[1]
    $category = $columns[2]
    $version = $columns[3]
    $status = $columns[4]
    $owner = $columns[5]
    $specificationPath = Normalize-MarkdownText -Text $columns[6]

    if ($capabilityId -notmatch '^CAP-\d{3,}$') {
        Write-Host "[ERROR] Invalid Capability ID: $capabilityId" -ForegroundColor Red
        $errors++
        continue
    }

    if ($registeredIds.ContainsKey($capabilityId)) {
        Write-Host "[ERROR] Duplicate Capability ID: $capabilityId" -ForegroundColor Red
        $errors++
        continue
    }

    $registeredIds[$capabilityId] = $specificationPath

    $normalizedSpecificationPath = $specificationPath.Replace(
        "/",
        [IO.Path]::DirectorySeparatorChar
    )

    if ($registeredPaths.ContainsKey($normalizedSpecificationPath)) {
        Write-Host "[ERROR] Duplicate specification path:" -ForegroundColor Red
        Write-Host "        $specificationPath"
        $errors++
        continue
    }

    $registeredPaths[$normalizedSpecificationPath] = $capabilityId

    $absoluteSpecificationPath = Join-Path $root $normalizedSpecificationPath

    if (-not (Test-Path -LiteralPath $absoluteSpecificationPath -PathType Leaf)) {
        Write-Host "[ERROR] Missing capability specification" -ForegroundColor Red
        Write-Host "        Capability: $capabilityId - $name"
        Write-Host "        Path      : $specificationPath"
        $errors++
        continue
    }

    $metadata = Get-DocumentMetadata -FilePath $absoluteSpecificationPath

    if ($metadata.DocumentId -ne $capabilityId) {
        Write-Host "[ERROR] Capability ID mismatch" -ForegroundColor Red
        Write-Host "        Registry : $capabilityId"
        Write-Host "        Document : $($metadata.DocumentId)"
        Write-Host "        File     : $specificationPath"
        $errors++
    }

    if ($metadata.Category -ne $category) {
        Write-Host "[ERROR] Capability category mismatch" -ForegroundColor Red
        Write-Host "        Capability: $capabilityId"
        Write-Host "        Registry  : $category"
        Write-Host "        Document  : $($metadata.Category)"
        $errors++
    }

    if ($metadata.Version -ne $version) {
        Write-Host "[ERROR] Capability version mismatch" -ForegroundColor Red
        Write-Host "        Capability: $capabilityId"
        Write-Host "        Registry  : $version"
        Write-Host "        Document  : $($metadata.Version)"
        $errors++
    }

    if ($metadata.Status -ne $status) {
        Write-Host "[ERROR] Capability status mismatch" -ForegroundColor Red
        Write-Host "        Capability: $capabilityId"
        Write-Host "        Registry  : $status"
        Write-Host "        Document  : $($metadata.Status)"
        $errors++
    }

    if ($metadata.Owner -ne $owner) {
        Write-Host "[ERROR] Capability owner mismatch" -ForegroundColor Red
        Write-Host "        Capability: $capabilityId"
        Write-Host "        Registry  : $owner"
        Write-Host "        Document  : $($metadata.Owner)"
        $errors++
    }

    $expectedCategoryDirectory = $category.ToLowerInvariant()
    $actualCategoryDirectory = Split-Path `
        -Leaf `
        (Split-Path -Parent $absoluteSpecificationPath)

    if ($actualCategoryDirectory -ne $expectedCategoryDirectory) {
        Write-Host "[ERROR] Capability directory/category mismatch" -ForegroundColor Red
        Write-Host "        Capability        : $capabilityId"
        Write-Host "        Expected directory: $expectedCategoryDirectory"
        Write-Host "        Actual directory  : $actualCategoryDirectory"
        $errors++
    }
}

$specificationFiles = Get-ChildItem `
    -LiteralPath $capabilitiesDirectory `
    -Recurse `
    -File `
    -Filter "CAP-*.md"

foreach ($file in $specificationFiles) {
             $relativePath = $file.FullName.Substring($root.Length + 1)
              $relativePath = $relativePath.Replace('/', '\')

    if (-not $registeredPaths.ContainsKey($relativePath)) {
        Write-Host "[ERROR] Unregistered capability specification" -ForegroundColor Red
        Write-Host "        File: $relativePath"
        $errors++
    }
}

Write-Host ""
Write-Host "Registered capabilities : $($registeredIds.Count)"
Write-Host "Specification files    : $($specificationFiles.Count)"
Write-Host "Warnings               : $warnings"
Write-Host "Errors                 : $errors"
Write-Host ""

if ($errors -eq 0) {
    Write-Host "Capability Registry validation PASSED." -ForegroundColor Green
    exit 0
}

Write-Host "Capability Registry validation FAILED." -ForegroundColor Red
exit 1