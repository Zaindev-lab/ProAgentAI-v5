Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$managerPath = Join-Path `
    (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) `
    "runtime\engine\Runtime_State_Manager.ps1"

. $managerPath

Write-Host "Creating Runtime State..."

$state = New-RuntimeState `
    -ProjectId "PROJECT-001" `
    -RequestId "REQUEST-001"

if ($state.status -ne "CREATED") {
    throw "Expected CREATED status."
}

Write-Host "Changing status to ANALYZING..."

$state = Set-RuntimeStateStatus `
    -State $state `
    -NewStatus "ANALYZING"

if ($state.status -ne "ANALYZING") {
    throw "Status transition failed."
}

$tempFile = Join-Path `
    $env:TEMP `
    "proagentai-runtime-state-test.json"

Save-RuntimeState `
    -State $state `
    -Path $tempFile

$loaded = Get-RuntimeState `
    -Path $tempFile

if ($loaded.status -ne "ANALYZING") {
    throw "Loaded state mismatch."
}

Remove-Item `
    -LiteralPath $tempFile `
    -Force

Write-Host ""
Write-Host "Runtime State Manager test PASSED." -ForegroundColor Green
