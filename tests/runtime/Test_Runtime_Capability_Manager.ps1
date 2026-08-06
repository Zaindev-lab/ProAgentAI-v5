Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\..\..\runtime\engine\Runtime_Capability_Manager.ps1"

Write-Host "Loading capability..."

$cap = Initialize-Capability `
    -CapabilityId "CAP-001"

if (-not $cap.Registered) {
    throw "Capability not loaded."
}

Write-Host ""
Write-Host "Runtime Capability Manager test PASSED." -ForegroundColor Green