Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\..\..\runtime\engine\Runtime_State_IO.ps1"

$template = Join-Path $PSScriptRoot "..\..\runtime\state\Runtime_State_Example.json"
$tempFile = Join-Path $env:TEMP "runtime-state-io-test.json"

Write-Host "Creating Runtime State file..."

New-RuntimeStateFile `
    -Destination $tempFile `
    -Template $template | Out-Null

Write-Host "Reading Runtime State..."

$state = Read-RuntimeState -Path $tempFile

$state.status = "ANALYZING"

Write-Host "Writing Runtime State..."

Write-RuntimeState `
    -State $state `
    -Path $tempFile

$loaded = Read-RuntimeState -Path $tempFile

if ($loaded.status -ne "ANALYZING") {
    throw "Runtime State IO test failed."
}

Remove-Item `
    -LiteralPath $tempFile `
    -Force

Write-Host ""
Write-Host "Runtime State IO test PASSED." -ForegroundColor Green