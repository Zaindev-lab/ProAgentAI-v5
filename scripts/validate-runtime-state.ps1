param(
    [string]$StateFile = ".\runtime\state\Runtime_State_Example.json"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ProAgentAI v5 Runtime State Validation"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $StateFile -PathType Leaf)) {
    Write-Host "[ERROR] Runtime State file not found:" -ForegroundColor Red
    Write-Host "        $StateFile"
    exit 1
}

try {
    $state = Get-Content `
        -LiteralPath $StateFile `
        -Raw `
        -Encoding utf8 |
        ConvertFrom-Json
}
catch {
    Write-Host "[ERROR] Invalid JSON." -ForegroundColor Red
    Write-Host "        $($_.Exception.Message)"
    exit 1
}

$errors = 0

$requiredFields = @(
    "schemaVersion",
    "stateId",
    "projectId",
    "requestId",
    "phase",
    "status",
    "completedSteps",
    "pendingSteps",
    "evidence",
    "errors",
    "warnings",
    "createdAt",
    "updatedAt"
)

foreach ($field in $requiredFields) {
    if ($null -eq $state.PSObject.Properties[$field]) {
        Write-Host "[ERROR] Missing required field: $field" -ForegroundColor Red
        $errors++
    }
}

$allowedPhases = @(
    "",
    "INTAKE",
    "REQUIREMENTS",
    "PLANNING",
    "DESIGN",
    "IMPLEMENTATION",
    "REVIEW",
    "VALIDATION",
    "DELIVERY"
)

$allowedStatuses = @(
    "CREATED",
    "ANALYZING",
    "WAITING_FOR_CLARIFICATION",
    "WAITING_FOR_APPROVAL",
    "READY_FOR_EXECUTION",
    "EXECUTING",
    "READY_FOR_REVIEW",
    "VALIDATING",
    "READY_FOR_DELIVERY",
    "COMPLETED",
    "PAUSED",
    "BLOCKED",
    "CANCELLED",
    "FAILED"
)

if (
    $null -ne $state.PSObject.Properties["phase"] -and
    $state.phase -notin $allowedPhases
) {
    Write-Host "[ERROR] Invalid phase: $($state.phase)" -ForegroundColor Red
    $errors++
}

if (
    $null -ne $state.PSObject.Properties["status"] -and
    $state.status -notin $allowedStatuses
) {
    Write-Host "[ERROR] Invalid status: $($state.status)" -ForegroundColor Red
    $errors++
}

$arrayFields = @(
    "completedSteps",
    "pendingSteps",
    "evidence",
    "errors",
    "warnings"
)

foreach ($field in $arrayFields) {
    if ($null -ne $state.PSObject.Properties[$field]) {
        $value = $state.$field

        if ($value -isnot [System.Array]) {
            Write-Host "[ERROR] Field must be an array: $field" -ForegroundColor Red
            $errors++
        }
    }
}

$dateFields = @(
    "createdAt",
    "updatedAt"
)

foreach ($field in $dateFields) {
    if ($null -ne $state.PSObject.Properties[$field]) {
        $value = $state.$field

        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $parsedDate = [DateTime]::MinValue

            if (-not [DateTime]::TryParse($value, [ref]$parsedDate)) {
                Write-Host "[ERROR] Invalid date value in $field`: $value" -ForegroundColor Red
                $errors++
            }
        }
    }
}

Write-Host ""

if ($errors -eq 0) {
    Write-Host "Runtime State validation PASSED." -ForegroundColor Green
    exit 0
}

Write-Host "$errors Runtime State validation error(s) found." -ForegroundColor Red
exit 1
