param()

$ErrorActionPreference = "Stop"
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$repositoryValidator = Join-Path $PSScriptRoot "validate-repository.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Quality Gate"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $repositoryValidator)) {
    Write-Host "[FAIL] Repository validator not found." -ForegroundColor Red
    exit 1
}

Push-Location $repositoryRoot

try {
    $global:LASTEXITCODE = 0

    & $repositoryValidator

    $validatorSucceeded = $?
    $validatorExitCode = $LASTEXITCODE

    if (-not $validatorSucceeded -or $validatorExitCode -ne 0) {
        Write-Host ""
        Write-Host "QUALITY GATE FAILED" -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    Write-Host "QUALITY GATE PASSED" -ForegroundColor Green
    exit 0
}
catch {
    Write-Host ""
    Write-Host "[FAIL] $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "QUALITY GATE FAILED" -ForegroundColor Red
    exit 1
}
finally {
    Pop-Location
}
