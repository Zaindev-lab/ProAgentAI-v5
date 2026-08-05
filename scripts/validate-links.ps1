param(
    [string]$DocsRoot = ".\docs",
    [string]$RepositoryRoot = "."
)

$ErrorActionPreference = "Stop"

Write-Host "===================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Link Validation"
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $DocsRoot)) {
    Write-Host "[ERROR] Documentation root not found: $DocsRoot" -ForegroundColor Red
    exit 1
}

$root = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$files = Get-ChildItem -Path $DocsRoot -Recurse -File -Filter "*.md"

$errors = 0
$warnings = 0
$checkedLinks = 0
$existingLinks = 0

function Normalize-MarkdownText {
    param([string]$Text)

    $normalized = $Text
    $normalized = $normalized -replace '\\+', ''
    $normalized = $normalized -replace '\*', ''
    $normalized = $normalized -replace '`', ''
    return $normalized.Trim()
}

function Normalize-MarkdownPath {
    param([string]$Path)

    $normalized = $Path.Trim()

    # إزالة Markdown escaping من أسماء الملفات
    $normalized = $normalized -replace '\\+_', '_'
    $normalized = $normalized -replace '\\+\-', '-'
    $normalized = $normalized -replace '\\+\.', '.'
    $normalized = $normalized -replace '\\+', ''

    # توحيد فواصل المسار
    $normalized = $normalized.Replace(
        "/",
        [IO.Path]::DirectorySeparatorChar
    )

    return $normalized
}

foreach ($file in $files) {
    $lines = Get-Content -LiteralPath $file.FullName -Encoding utf8
    $section = "None"

    # Metadata موجود في رأس الوثيقة فقط.
    # نتوقف عند أول عنوان H2 مثل ## Purpose.
    for ($lineNumber = 0; $lineNumber -lt $lines.Count; $lineNumber++) {
        $line = $lines[$lineNumber]
        $normalizedLine = Normalize-MarkdownText -Text $line

        if ($line -match '^\s*\\?#{2,6}\s+') {
            break
        }

        if ($normalizedLine -match '^Depends\s+on\s*:\s*$') {
            $section = "DependsOn"
            continue
        }

        if ($normalizedLine -match '^Referenced\s+by\s*:\s*$') {
            $section = "ReferencedBy"
            continue
        }

        # أي حقل Metadata جديد ينهي القسم الحالي
        if (
            $normalizedLine -match '^(Document ID|Version|Status|Owner|Category|Last Updated|Date)\s*:'
        ) {
            $section = "None"
            continue
        }

        if ($section -eq "None") {
            continue
        }

        $matches = [regex]::Matches(
            $line,
            '`(?<path>(?:docs|scripts)[/\\][^`]+?\.md)`',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )

        foreach ($match in $matches) {
            $rawPath = $match.Groups["path"].Value
            $normalizedPath = Normalize-MarkdownPath -Path $rawPath
            $targetPath = Join-Path $root $normalizedPath

            $checkedLinks++

            if (Test-Path -LiteralPath $targetPath -PathType Leaf) {
                $existingLinks++
                continue
            }

            if ($section -eq "ReferencedBy") {
                Write-Host "[WARN] Future or missing reference" -ForegroundColor Yellow
                Write-Host "       Source : $($file.FullName)"
                Write-Host "       Line   : $($lineNumber + 1)"
                Write-Host "       Target : $normalizedPath"
                $warnings++
                continue
            }

            Write-Host "[ERROR] Broken required dependency" -ForegroundColor Red
            Write-Host "        Source : $($file.FullName)"
            Write-Host "        Line   : $($lineNumber + 1)"
            Write-Host "        Target : $normalizedPath"
            $errors++
        }
    }
}

Write-Host ""
Write-Host "Checked references : $checkedLinks"
Write-Host "Existing references: $existingLinks"
Write-Host "Warnings           : $warnings"
Write-Host "Errors             : $errors"
Write-Host ""

if ($errors -eq 0) {
    Write-Host "Link validation PASSED." -ForegroundColor Green

    if ($warnings -gt 0) {
        Write-Host "$warnings future reference warning(s) detected." -ForegroundColor Yellow
    }

    exit 0
}

Write-Host "Link validation FAILED." -ForegroundColor Red
exit 1