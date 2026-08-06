Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Start-CapabilityExecution {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$State
    )

    if ([string]::IsNullOrWhiteSpace([string]$State.activeCapability)) {
        throw "No active capability is available."
    }

    $pendingSteps = @($State.pendingSteps)
    $activeCapability = [string]$State.activeCapability

    $activeStep = $pendingSteps |
        Where-Object { $_.stepId -eq $activeCapability } |
        Select-Object -First 1

    if ($null -eq $activeStep) {
        throw "Active capability was not found in pending steps: $activeCapability"
    }

    $activeStep.status = "IN_PROGRESS"
    $State.updatedAt = [DateTime]::UtcNow.ToString("o")

    return $State
}

function Complete-CapabilityExecution {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$State
    )

    if ([string]::IsNullOrWhiteSpace([string]$State.activeCapability)) {
        throw "No active capability is available."
    }

    $activeCapability = [string]$State.activeCapability
    $pendingSteps = @($State.pendingSteps)
    $completedSteps = @($State.completedSteps)

    $activeStep = $pendingSteps |
        Where-Object { $_.stepId -eq $activeCapability } |
        Select-Object -First 1

    if ($null -eq $activeStep) {
        throw "Active capability was not found in pending steps: $activeCapability"
    }

    $activeStep.status = "COMPLETED"

    $remainingSteps = @(
        $pendingSteps |
        Where-Object { $_.stepId -ne $activeCapability }
    )

    $completedSteps += $activeStep

    $State.pendingSteps = $remainingSteps
    $State.completedSteps = $completedSteps

    if ($remainingSteps.Count -gt 0) {
        $State.activeCapability = $remainingSteps[0].stepId
    }

    if ($remainingSteps.Count -eq 0) {
        $State.activeCapability = $null
    }

    $State.updatedAt = [DateTime]::UtcNow.ToString("o")

    return $State
}

function Fail-CapabilityExecution {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$State,

        [string]$Reason = "Capability execution failed."
    )

    if ([string]::IsNullOrWhiteSpace([string]$State.activeCapability)) {
        throw "No active capability is available."
    }

    $activeCapability = [string]$State.activeCapability
    $pendingSteps = @($State.pendingSteps)

    $activeStep = $pendingSteps |
        Where-Object { $_.stepId -eq $activeCapability } |
        Select-Object -First 1

    if ($null -eq $activeStep) {
        throw "Active capability was not found in pending steps: $activeCapability"
    }

    $activeStep.status = "FAILED"

    $State.status = "FAILED"
    $State.errors = @($State.errors) + [pscustomobject]@{
        code      = "CAPABILITY_EXECUTION_FAILED"
        message   = $Reason
        capability = $activeCapability
        timestamp = [DateTime]::UtcNow.ToString("o")
    }

    $State.updatedAt = [DateTime]::UtcNow.ToString("o")

    return $State
}
