param(
    [string]$DocsRoot = ".\docs"
)

Write-Host "===================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Document ID Check "
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

$pattern = 'Document ID:\s*(.+)$'
$ids = @{}
$errors = 0

$files = Get-ChildItem $DocsRoot -Recurse -Filter *.md

foreach ($file in $files) {

    $match = Select-String `
        -Path $file.FullName `
        -Pattern $pattern

    if (-not $match) {

        Write-Host "[ERROR] Missing Document ID: $($file.FullName)" -ForegroundColor Red
        $errors++
        continue
    }

    $id = $match.Matches[0].Groups[1].Value.Trim()

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
}
else {

    Write-Host ""
    Write-Host "$errors validation error(s) detected." -ForegroundColor Yellow
    exit 1
}