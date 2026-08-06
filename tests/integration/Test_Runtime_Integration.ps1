Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$runtimeEnginePath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Engine.ps1"

$stateIoPath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_State_IO.ps1"

. $runtimeEnginePath
. $stateIoPath

$tempFile = Join-Path `
    $env:TEMP `
    "proagentai-runtime-integration-test.json"

Write-Host "Starting Runtime integration test..."

$state = Start-ProAgentRuntime `
    -ProjectId "PROJECT-INTEGRATION-001" `
    -RequestId "REQUEST-INTEGRATION-001" `
    -WorkflowId "WF-001"

Write-RuntimeState `
    -State $state `
    -Path $tempFile

$loadedState = Read-RuntimeState `
    -Path $tempFile

if ($loadedState.projectId -ne $state.projectId) {
    throw "Project ID was not preserved."
}

if ($loadedState.requestId -ne $state.requestId) {
    throw "Request ID was not preserved."
}

if ($loadedState.activeWorkflow -ne "WF-001") {
    throw "Workflow was not preserved."
}

if ($loadedState.activeCapability -ne "CAP-001") {
    throw "Active capability was not preserved."
}

if (@($loadedState.pendingSteps).Count -ne 7) {
    throw "Pending workflow steps were not preserved."
}

Remove-Item `
    -LiteralPath $tempFile `
    -Force

Write-Host ""
Write-Host "Runtime Integration test PASSED." -ForegroundColor Green
