param(
    [string]$DocsRoot = ".\docs"
)

Write-Host "===================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Document ID Check "
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $DocsRoot)) {
    Write-Host "[ERROR] Documentation root not found: $DocsRoot" -ForegroundColor Red
    exit 1
}

$ids = @{}
$errors = 0
$validIdPattern = "^[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)*-\d{3,}$"

$documentIdPattern = '(?im)^\s*\\?\*\\?\*Document\s+ID\s*:\s*\\?\*\\?\*\s*(?<id>[A-Z][A-Z0-9-]*-\d{3,})\s*$'

$files = Get-ChildItem -Path $DocsRoot -Recurse -File -Filter "*.md"

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $matches = [regex]::Matches($content, $documentIdPattern)

    if ($matches.Count -eq 0) {
        Write-Host "[ERROR] Missing Document ID: $($file.FullName)" -ForegroundColor Red
        $errors++
        continue
    }

    $documentIds = @(
        $matches |
        ForEach-Object { $_.Groups["id"].Value.Trim() } |
        Select-Object -Unique
    )

    if ($documentIds.Count -gt 1) {
        Write-Host "[ERROR] Multiple Document IDs: $($file.FullName)" -ForegroundColor Red
        Write-Host "        IDs: $($documentIds -join ', ')"
        $errors++
        continue
    }

    $id = $documentIds[0]

    if ($id -notmatch $validIdPattern) {
        Write-Host "[ERROR] Invalid Document ID format '$id'" -ForegroundColor Red
        Write-Host "        File: $($file.FullName)"
        $errors++
        continue
    }

    if ($ids.ContainsKey($id)) {
        Write-Host "[ERROR] Duplicate Document ID '$id'" -ForegroundColor Red
        Write-Host "        First : $($ids[$id])"
        Write-Host "        Second: $($file.FullName)"
        $errors++
    }
    else {
        $ids[$id] = $file.FullName
    }
}

Write-Host ""

if ($errors -eq 0) {
    Write-Host "Document ID validation PASSED." -ForegroundColor Green
    Write-Host "$($ids.Count) unique document IDs found."
    exit 0
}

Write-Host "$errors validation error(s) detected." -ForegroundColor Yellow
exit 1
