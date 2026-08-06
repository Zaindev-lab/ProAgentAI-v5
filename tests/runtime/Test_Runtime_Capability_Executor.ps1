Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$runtimeEnginePath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Engine.ps1"

$capabilityExecutorPath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Capability_Executor.ps1"

. $runtimeEnginePath
. $capabilityExecutorPath

Write-Host "Starting Runtime..."

$state = Start-ProAgentRuntime `
    -ProjectId "PROJECT-001" `
    -RequestId "REQUEST-001" `
    -WorkflowId "WF-001"

if ($state.activeCapability -ne "CAP-001") {
    throw "Expected CAP-001 as the active capability."
}

$initialPendingCount = @($state.pendingSteps).Count
$initialCompletedCount = @($state.completedSteps).Count

Write-Host "Completing CAP-001..."

$state = Complete-CapabilityExecution `
    -State $state

$newPendingCount = @($state.pendingSteps).Count
$newCompletedCount = @($state.completedSteps).Count

if ($newCompletedCount -ne ($initialCompletedCount + 1)) {
    throw "Completed step count was not increased."
}

if ($newPendingCount -ne ($initialPendingCount - 1)) {
    throw "Pending step count was not decreased."
}

if ($state.completedSteps[0].stepId -ne "CAP-001") {
    throw "CAP-001 was not moved to completed steps."
}

if ($state.completedSteps[0].status -ne "COMPLETED") {
    throw "CAP-001 was not marked COMPLETED."
}

if ($newPendingCount -gt 0) {
    if ($state.activeCapability -ne "CAP-002") {
        throw "Expected CAP-002 as the next active capability."
    }
}

Write-Host ""
Write-Host "Runtime Capability Executor test PASSED." -ForegroundColor Green
