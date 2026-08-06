# Runtime State Model

**Document ID:** RT-002

**Version:** 5.0.0-alpha

**Status:** Draft

**Owner:** Product Owner

**Category:** Runtime

**Depends on:**

- `docs/core/State_Model.md`
- `docs/core/Execution_Model.md`
- `docs/runtime/Runtime_Identity.md`

**Referenced by:**

- `runtime/state/Runtime_State_Schema.json`

## Purpose

This document defines the Runtime State used by ProAgentAI v5.

The Runtime State records the current execution status of a project.

## Required Fields

- schemaVersion
- stateId
- projectId
- requestId
- phase
- status
- completedSteps
- pendingSteps
- evidence
- errors
- warnings
- createdAt
- updatedAt

## Optional Fields

- activeWorkflow
- activeCapability
- blockers
- approvalState
- validationState
- deliveryState
- metadata

## Runtime Status

Supported values:

- CREATED
- ANALYZING
- WAITING_FOR_CLARIFICATION
- WAITING_FOR_APPROVAL
- READY_FOR_EXECUTION
- EXECUTING
- READY_FOR_REVIEW
- VALIDATING
- READY_FOR_DELIVERY
- COMPLETED
- PAUSED
- BLOCKED
- CANCELLED
- FAILED

## State Lifecycle

CREATED

↓

ANALYZING

↓

READY_FOR_EXECUTION

↓

EXECUTING

↓

READY_FOR_REVIEW

↓

VALIDATING

↓

READY_FOR_DELIVERY

↓

COMPLETED

## Transition Rules

A transition is valid only when:

- required inputs exist
- required approvals exist
- no blockers exist
- required evidence exists

## Blocking Rules

Runtime enters BLOCKED when:

- information is missing
- approval is missing
- validation fails
- workflow is undefined
- capability is undefined

## Completion Rules

Runtime becomes COMPLETED only when:

- workflow completed
- validation passed
- evidence recorded
- blockers resolved

## Security Rules

Runtime state must never store:

- passwords
- API keys
- access tokens
- private certificates

## Evidence Status

**Document created:** CREATED

**Runtime implementation:** NOT IMPLEMENTED

**Runtime execution:** NOT TESTED
