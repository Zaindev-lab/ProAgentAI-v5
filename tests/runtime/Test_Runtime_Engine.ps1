Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$runtimeEnginePath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Engine.ps1"

. $runtimeEnginePath

Write-Host "Starting ProAgent Runtime..."

$state = Start-ProAgentRuntime `
    -ProjectId "PROJECT-001" `
    -RequestId "REQUEST-001" `
    -WorkflowId "WF-001"

if ($state.projectId -ne "PROJECT-001") {
    throw "Project ID mismatch."
}

if ($state.requestId -ne "REQUEST-001") {
    throw "Request ID mismatch."
}

if ($state.activeWorkflow -ne "WF-001") {
    throw "Workflow was not initialized."
}

if ($state.activeCapability -ne "CAP-001") {
    throw "First capability was not selected."
}

if ([string]::IsNullOrWhiteSpace($state.status)) {
    throw "Runtime status is missing."
}

Write-Host ""
Write-Host "Runtime Engine test PASSED." -ForegroundColor Green
