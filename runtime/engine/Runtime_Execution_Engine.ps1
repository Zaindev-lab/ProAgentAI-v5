Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\Runtime_State_Manager.ps1"
. "$PSScriptRoot\Runtime_Workflow_Manager.ps1"
. "$PSScriptRoot\Runtime_Capability_Manager.ps1"
. "$PSScriptRoot\Runtime_State_IO.ps1"

function Start-RuntimeExecution {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectId,

        [Parameter(Mandatory)]
        [string]$RequestId,

        [Parameter(Mandatory)]
        [string]$WorkflowId
    )

    $state = New-RuntimeState `
        -ProjectId $ProjectId `
        -RequestId $RequestId

    $state = Initialize-RuntimeWorkflow `
        -State $state `
        -WorkflowId $WorkflowId

    if ($state.pendingSteps.Count -gt 0) {

        $firstCapability = $state.pendingSteps[0].stepId

        $null = Initialize-Capability `
            -CapabilityId $firstCapability

        $state.activeCapability = $firstCapability
    }

    return $state
}