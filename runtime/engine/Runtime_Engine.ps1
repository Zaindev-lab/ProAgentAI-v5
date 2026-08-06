Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\Runtime_State_Manager.ps1"
. "$PSScriptRoot\Runtime_State_IO.ps1"
. "$PSScriptRoot\Runtime_Workflow_Manager.ps1"
. "$PSScriptRoot\Runtime_Capability_Manager.ps1"
. "$PSScriptRoot\Runtime_Execution_Engine.ps1"

function Start-ProAgentRuntime {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $true)]
        [string]$RequestId,

        [Parameter(Mandatory = $true)]
        [string]$WorkflowId
    )

    return Start-RuntimeExecution `
        -ProjectId $ProjectId `
        -RequestId $RequestId `
        -WorkflowId $WorkflowId
}
