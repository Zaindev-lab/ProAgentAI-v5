Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$enginePath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Execution_Engine.ps1"

. $enginePath

Write-Host "Starting Runtime Execution Engine..."

$state = Start-RuntimeExecution `
    -ProjectId "PROJECT-EXECUTION-001" `
    -RequestId "REQUEST-EXECUTION-001" `
    -WorkflowId "WF-001"

if ($state.projectId -ne "PROJECT-EXECUTION-001") {
    throw "Project ID mismatch."
}

if ($state.requestId -ne "REQUEST-EXECUTION-001") {
    throw "Request ID mismatch."
}

if ($state.activeWorkflow -ne "WF-001") {
    throw "Workflow initialization failed."
}

if ($state.activeCapability -ne "CAP-001") {
    throw "Expected CAP-001 as the first active capability."
}

if (@($state.pendingSteps).Count -ne 7) {
    throw "Expected seven pending workflow steps."
}

Write-Host ""
Write-Host "Runtime Execution Engine test PASSED." -ForegroundColor Green
