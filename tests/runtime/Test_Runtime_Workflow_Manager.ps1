Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$stateManagerPath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_State_Manager.ps1"

$workflowManagerPath = Join-Path `
    $repositoryRoot `
    "runtime\engine\Runtime_Workflow_Manager.ps1"

$workflowRegistryPath = Join-Path `
    $repositoryRoot `
    "docs\workflows\Workflow_Registry.md"

. $stateManagerPath
. $workflowManagerPath

Write-Host "Loading Workflow Registry..."

$registry = @(
    Get-WorkflowRegistry `
        -RegistryPath $workflowRegistryPath
)

if ($registry.Count -lt 1) {
    throw "No workflows were loaded from the registry."
}

Write-Host "Loading WF-001..."

$workflow = Get-RegisteredWorkflow `
    -WorkflowId "WF-001" `
    -RegistryPath $workflowRegistryPath

if ($workflow.WorkflowId -ne "WF-001") {
    throw "WF-001 was not loaded correctly."
}

$specificationPath = Join-Path `
    $repositoryRoot `
    ($workflow.SpecificationPath.Replace("/", "\"))

Write-Host "Reading workflow capability sequence..."

$capabilityIds = Get-WorkflowCapabilitySequence `
    -SpecificationPath $specificationPath

$expectedCapabilityIds = @(
    "CAP-001",
    "CAP-002",
    "CAP-003",
    "CAP-004",
    "CAP-005",
    "CAP-006",
    "CAP-007"
)

if ($capabilityIds.Count -ne $expectedCapabilityIds.Count) {
    throw "Unexpected capability count. Expected 7, found $($capabilityIds.Count)."
}

for ($index = 0; $index -lt $expectedCapabilityIds.Count; $index++) {
    if ($capabilityIds[$index] -ne $expectedCapabilityIds[$index]) {
        throw "Capability order mismatch at position $index."
    }
}

Write-Host "Creating Runtime State..."

$state = New-RuntimeState `
    -ProjectId "PROJECT-001" `
    -RequestId "REQUEST-001"

Write-Host "Initializing WF-001..."

$state = Initialize-RuntimeWorkflow `
    -State $state `
    -WorkflowId "WF-001" `
    -RegistryPath $workflowRegistryPath

if ($state.activeWorkflow -ne "WF-001") {
    throw "Active workflow was not assigned."
}

if ($state.pendingSteps.Count -ne 7) {
    throw "Pending workflow steps were not initialized correctly."
}

if ($state.completedSteps.Count -ne 0) {
    throw "Completed steps should be empty."
}

if ($state.pendingSteps[0].stepId -ne "CAP-001") {
    throw "The first pending capability should be CAP-001."
}

if ($state.pendingSteps[6].stepId -ne "CAP-007") {
    throw "The final pending capability should be CAP-007."
}

Write-Host ""
Write-Host "Runtime Workflow Manager test PASSED." -ForegroundColor Green
