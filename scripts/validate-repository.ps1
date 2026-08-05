param(
    [string]$RepositoryRoot = "."
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path $RepositoryRoot).Path
$scriptsRoot = Join-Path $root "scripts"
$errors = 0

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Repository Validation"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

function Invoke-ValidationStep {
    param(
        [string]$Name,
        [scriptblock]$Action
    )

    Write-Host "[RUN] $Name" -ForegroundColor Cyan

    try {
        & $Action

        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Command exited with code $LASTEXITCODE"
        }

        Write-Host "[PASS] $Name" -ForegroundColor Green
    }
    catch {
        Write-Host "[FAIL] $Name" -ForegroundColor Red
        Write-Host "       $($_.Exception.Message)" -ForegroundColor Red
        $script:errors++
    }

    Write-Host ""
}

Push-Location $root

try {
    Invoke-ValidationStep "Required document metadata" {
        & (Join-Path $scriptsRoot "validate-docs.ps1")
    }

    Invoke-ValidationStep "Unique document identifiers" {
        & (Join-Path $scriptsRoot "check-document-ids.ps1")
    }

    Invoke-ValidationStep "Git whitespace and formatting" {
        git diff --check

        if ($LASTEXITCODE -ne 0) {
            throw "git diff --check failed"
        }
    }
}
finally {
    Pop-Location
}

Write-Host "========================================" -ForegroundColor Cyan

if ($errors -eq 0) {
    Write-Host "Repository validation PASSED." -ForegroundColor Green
    exit 0
}

Write-Host "$errors validation step(s) failed." -ForegroundColor Red
exit 1
