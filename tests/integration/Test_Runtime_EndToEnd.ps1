Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$runtimeEnginePath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Engine.ps1"

$capabilityExecutorPath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Capability_Executor.ps1"

$stateIoPath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_State_IO.ps1"

. $runtimeEnginePath
. $capabilityExecutorPath
. $stateIoPath

$tempFile = Join-Path `
    $env:TEMP `
    "proagentai-runtime-e2e-test.json"

Write-Host "Starting Runtime End-to-End test..."

$state = Start-ProAgentRuntime `
    -ProjectId "PROJECT-E2E-001" `
    -RequestId "REQUEST-E2E-001" `
    -WorkflowId "WF-001"

$state = Start-CapabilityExecution `
    -State $state

if ($state.pendingSteps[0].status -ne "IN_PROGRESS") {
    throw "CAP-001 did not enter IN_PROGRESS."
}

$state = Complete-CapabilityExecution `
    -State $state

if (@($state.completedSteps).Count -ne 1) {
    throw "Completed step was not recorded."
}

if ($state.completedSteps[0].stepId -ne "CAP-001") {
    throw "CAP-001 was not completed."
}

if ($state.activeCapability -ne "CAP-002") {
    throw "Runtime did not advance to CAP-002."
}

Write-RuntimeState `
    -State $state `
    -Path $tempFile

$loadedState = Read-RuntimeState `
    -Path $tempFile

if ($loadedState.activeCapability -ne "CAP-002") {
    throw "Active capability was not preserved after reload."
}

if (@($loadedState.completedSteps).Count -ne 1) {
    throw "Completed steps were not preserved after reload."
}

Remove-Item `
    -LiteralPath $tempFile `
    -Force

Write-Host ""
Write-Host "Runtime End-to-End test PASSED." -ForegroundColor Green
