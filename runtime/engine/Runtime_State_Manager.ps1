Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$AllowedTransitions = @{
    "CREATED" = @(
        "ANALYZING",
        "CANCELLED",
        "FAILED"
    )

    "ANALYZING" = @(
        "WAITING_FOR_CLARIFICATION",
        "WAITING_FOR_APPROVAL",
        "READY_FOR_EXECUTION",
        "BLOCKED",
        "CANCELLED",
        "FAILED"
    )

    "WAITING_FOR_CLARIFICATION" = @(
        "ANALYZING",
        "CANCELLED",
        "FAILED"
    )

    "WAITING_FOR_APPROVAL" = @(
        "READY_FOR_EXECUTION",
        "BLOCKED",
        "CANCELLED",
        "FAILED"
    )

    "READY_FOR_EXECUTION" = @(
        "EXECUTING",
        "BLOCKED",
        "CANCELLED",
        "FAILED"
    )

    "EXECUTING" = @(
        "READY_FOR_REVIEW",
        "PAUSED",
        "BLOCKED",
        "CANCELLED",
        "FAILED"
    )

    "READY_FOR_REVIEW" = @(
        "VALIDATING",
        "EXECUTING",
        "BLOCKED",
        "CANCELLED",
        "FAILED"
    )

    "VALIDATING" = @(
        "READY_FOR_DELIVERY",
        "EXECUTING",
        "BLOCKED",
        "FAILED"
    )

    "READY_FOR_DELIVERY" = @(
        "COMPLETED",
        "BLOCKED",
        "FAILED"
    )

    "PAUSED" = @(
        "EXECUTING",
        "BLOCKED",
        "CANCELLED",
        "FAILED"
    )

    "BLOCKED" = @(
        "ANALYZING",
        "READY_FOR_EXECUTION",
        "EXECUTING",
        "VALIDATING",
        "CANCELLED",
        "FAILED"
    )

    "COMPLETED" = @()
    "CANCELLED" = @()
    "FAILED" = @()
}

function New-RuntimeState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $true)]
        [string]$RequestId,

        [string]$Phase = "INTAKE"
    )

    $timestamp = [DateTime]::UtcNow.ToString("o")

    return [ordered]@{
        schemaVersion    = "1.0.0"
        stateId          = "STATE-$([Guid]::NewGuid().ToString('N'))"
        projectId        = $ProjectId
        requestId        = $RequestId
        phase            = $Phase
        status           = "CREATED"
        activeWorkflow   = $null
        activeCapability = $null
        completedSteps   = @()
        pendingSteps     = @()
        evidence         = @()
        blockers         = @()
        errors           = @()
        warnings         = @()
        approvalState    = "NOT_REQUIRED"
        validationState  = "NOT_STARTED"
        deliveryState    = "NOT_READY"
        createdAt        = $timestamp
        updatedAt        = $timestamp
    }
}

function Get-RuntimeState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Runtime state file not found: $Path"
    }

    try {
        return Get-Content `
            -LiteralPath $Path `
            -Raw `
            -Encoding utf8 |
            ConvertFrom-Json
    }
    catch {
        throw "Unable to read Runtime state JSON: $($_.Exception.Message)"
    }
}

function Save-RuntimeState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$State,

        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $parentDirectory = Split-Path -Parent $Path

    if (
        -not [string]::IsNullOrWhiteSpace($parentDirectory) -and
        -not (Test-Path -LiteralPath $parentDirectory)
    ) {
        New-Item `
            -ItemType Directory `
            -Path $parentDirectory `
            -Force | Out-Null
    }

    $State.updatedAt = [DateTime]::UtcNow.ToString("o")

    $json = $State |
        ConvertTo-Json -Depth 20

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

    [System.IO.File]::WriteAllText(
        $Path,
        $json.TrimEnd() + "`n",
        $utf8NoBom
    )
}

function Set-RuntimeStateStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$State,

        [Parameter(Mandatory = $true)]
        [string]$NewStatus
    )

    $currentStatus = [string]$State.status

    if (-not $AllowedTransitions.ContainsKey($currentStatus)) {
        throw "Unknown current Runtime status: $currentStatus"
    }

    if ($NewStatus -notin $AllowedTransitions[$currentStatus]) {
        throw "Invalid Runtime transition: $currentStatus -> $NewStatus"
    }

    $State.status = $NewStatus
    $State.updatedAt = [DateTime]::UtcNow.ToString("o")

    return $State
}
