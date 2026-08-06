Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-WorkflowRegistry {
    [CmdletBinding()]
    param(
        [string]$RegistryPath = ".\docs\workflows\Workflow_Registry.md"
    )

    if (-not (Test-Path -LiteralPath $RegistryPath -PathType Leaf)) {
        throw "Workflow Registry not found: $RegistryPath"
    }

    $workflows = @()

    foreach ($line in Get-Content -LiteralPath $RegistryPath -Encoding utf8) {
        if ($line -notmatch '^\s*\|\s*WF-\d{3,}\s*\|') {
            continue
        }

        $columns = @(
            $line.Trim().Trim('|').Split('|') |
            ForEach-Object { $_.Trim() }
        )

        if ($columns.Count -lt 4) {
            throw "Invalid Workflow Registry row: $line"
        }

        $specificationPath = $columns[3] `
            -replace '`', '' `
            -replace '\\+_', '_'

        $workflows += [pscustomobject]@{
            WorkflowId       = $columns[0]
            Name             = $columns[1]
            Status           = $columns[2]
            SpecificationPath = $specificationPath
        }
    }

    return $workflows
}

function Get-RegisteredWorkflow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkflowId,

        [string]$RegistryPath = ".\docs\workflows\Workflow_Registry.md"
    )

    $workflow = Get-WorkflowRegistry -RegistryPath $RegistryPath |
        Where-Object { $_.WorkflowId -eq $WorkflowId } |
        Select-Object -First 1

    if ($null -eq $workflow) {
        throw "Workflow is not registered: $WorkflowId"
    }

    return $workflow
}

function Get-WorkflowCapabilitySequence {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SpecificationPath
    )

    if (-not (Test-Path -LiteralPath $SpecificationPath -PathType Leaf)) {
        throw "Workflow specification not found: $SpecificationPath"
    }

    $content = Get-Content `
        -LiteralPath $SpecificationPath `
        -Raw `
        -Encoding utf8

    $matches = [regex]::Matches(
        $content,
        '\bCAP-\d{3,}\b'
    )

    $capabilityIds = @(
        $matches |
        ForEach-Object { $_.Value } |
        Select-Object -Unique
    )

    if ($capabilityIds.Count -eq 0) {
        throw "No capabilities found in workflow: $SpecificationPath"
    }

    return $capabilityIds
}

function Initialize-RuntimeWorkflow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$State,

        [Parameter(Mandatory = $true)]
        [string]$WorkflowId,

        [string]$RegistryPath = ".\docs\workflows\Workflow_Registry.md"
    )

    $workflow = Get-RegisteredWorkflow `
        -WorkflowId $WorkflowId `
        -RegistryPath $RegistryPath

    $capabilityIds = Get-WorkflowCapabilitySequence `
        -SpecificationPath $workflow.SpecificationPath

    $pendingSteps = @()

    foreach ($capabilityId in $capabilityIds) {
        $pendingSteps += [pscustomobject]@{
            stepId       = $capabilityId
            name         = $capabilityId
            status       = "PLANNED"
        }
    }

    $State.activeWorkflow = $WorkflowId
    $State.activeCapability = $null
    $State.pendingSteps = $pendingSteps
    $State.completedSteps = @()
    $State.updatedAt = [DateTime]::UtcNow.ToString("o")

    return $State
}
