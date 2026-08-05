param(
    [string]$DocsRoot = ".\docs"
)

Write-Host "===================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Documentation Check "
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

$requiredFields = @(
    "Document ID:",
    "Version:",
    "Status:",
    "Owner:"
)

$files = Get-ChildItem $DocsRoot -Recurse -Filter *.md

$errors = 0

foreach ($file in $files) {

    $content = Get-Content $file.FullName -Raw

    foreach ($field in $requiredFields) {

        if ($content -notmatch [regex]::Escape($field)) {

            Write-Host "[ERROR] $($file.FullName) : Missing '$field'" -ForegroundColor Red
            $errors++
        }
    }
}

Write-Host ""

if ($errors -eq 0) {

    Write-Host "Documentation validation PASSED." -ForegroundColor Green
}
else {

    Write-Host "$errors validation error(s) found." -ForegroundColor Yellow
    exit 1
}