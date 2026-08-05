\# State Model



\*\*Document ID:\*\* CORE-004



\*\*Version:\*\* 5.0.0-alpha



\*\*Status:\*\* Draft



\*\*Owner:\*\* Product Owner



\*\*Category:\*\* Architecture



\*\*Depends on:\*\*



\- `docs/governance/Documentation\_Standard.md`

\- `docs/core/System\_Model.md`

\- `docs/core/Component\_Model.md`

\- `docs/core/Execution\_Model.md`

\- `docs/architecture/Runtime\_Architecture.md`



\*\*Referenced by:\*\*



\- `docs/core/Knowledge\_Model.md`

\- `docs/architecture/Workflow\_Architecture.md`

\- `docs/architecture/Validation\_Architecture.md`

\- `docs/architecture/Delivery\_Architecture.md`

\- future SaaS project-state implementation



\*\*Last Updated:\*\* 2026-08-05



\## Purpose



This document defines the official state model of ProAgentAI v5.



It specifies how project, workflow, task, approval, validation, evidence, and delivery states are represented and how valid transitions occur.



The state model preserves traceability, recoverability, governance, and evidence integrity throughout project execution.



\## State Model Objectives



The state model must:



\- represent the current project condition

\- preserve project history

\- prevent invalid transitions

\- preserve approved baselines

\- record blockers and approvals

\- associate claims with evidence

\- support recovery after interruption

\- support future SaaS persistence



\## State Domains



ProAgentAI maintains separate but related state domains:



1\. Project State

2\. Request State

3\. Workflow State

4\. Task State

5\. Approval State

6\. Validation State

7\. Evidence State

8\. Delivery State



A state change in one domain may affect another domain, but each domain retains its own status.



\## Project State



Project State represents the overall condition of a project.



\### Project State Values



\- NOT STARTED

\- INTAKE

\- REQUIREMENTS

\- PLANNING

\- DESIGN

\- IMPLEMENTATION

\- REVIEW

\- VALIDATION

\- DELIVERY PREPARATION

\- DELIVERED

\- BLOCKED

\- PAUSED

\- CANCELLED

\- COMPLETED



\### Project State Record



A Project State record should contain:



\- Project ID

\- Project name

\- Current phase

\- Current status

\- Approved baseline

\- Completed work

\- Work in progress

\- Blockers

\- Open risks

\- Assumptions

\- Decisions

\- Approvals

\- Evidence references

\- Artifacts

\- Next action

\- Last valid state

\- Last updated timestamp



\## Request State



Request State represents the lifecycle of one user request.



\### Request State Values



\- RECEIVED

\- CLASSIFYING

\- WAITING FOR CLARIFICATION

\- CLASSIFIED

\- ANALYZING

\- READY FOR DECISION

\- WAITING FOR APPROVAL

\- READY FOR EXECUTION

\- EXECUTING

\- READY FOR REVIEW

\- VALIDATING

\- READY FOR DELIVERY

\- DELIVERED

\- BLOCKED

\- CANCELLED

\- COMPLETED



\### Request Transition Flow



```text

RECEIVED

&#x20;   ↓

CLASSIFYING

&#x20;   ↓

CLASSIFIED

&#x20;   ↓

ANALYZING

&#x20;   ↓

READY FOR DECISION

&#x20;   ↓

READY FOR EXECUTION

&#x20;   ↓

EXECUTING

&#x20;   ↓

READY FOR REVIEW

&#x20;   ↓

VALIDATING

&#x20;   ↓

READY FOR DELIVERY

&#x20;   ↓

DELIVERED

&#x20;   ↓

COMPLETED

```



Alternative transitions may lead to:



\- WAITING FOR CLARIFICATION

\- WAITING FOR APPROVAL

\- BLOCKED

\- CANCELLED



\## Workflow State



Workflow State represents the lifecycle of the selected primary workflow.



\### Workflow State Values



\- NOT SELECTED

\- SELECTED

\- INITIALIZED

\- IN PROGRESS

\- PAUSED

\- WAITING FOR INPUT

\- WAITING FOR APPROVAL

\- READY FOR REVIEW

\- VALIDATING

\- REPAIR REQUIRED

\- BLOCKED

\- COMPLETED

\- CANCELLED



\### Workflow State Rules



\- only one primary workflow may be active for one request

\- a workflow must be selected before initialization

\- workflow execution must follow approved step order

\- a paused workflow preserves its current step

\- a blocked workflow must identify the blocking condition

\- a completed workflow must have completion evidence

\- workflow switching requires a new decision process



\## Task State



Task State represents one executable unit within a workflow.



\### Task State Values



\- PLANNED

\- READY

\- IN PROGRESS

\- WAITING FOR INPUT

\- WAITING FOR APPROVAL

\- READY FOR REVIEW

\- REPAIR REQUIRED

\- BLOCKED

\- VERIFIED

\- COMPLETED

\- CANCELLED



\### Task Completion Requirements



A task may be marked COMPLETED only when:



\- required inputs were available

\- expected outputs exist

\- acceptance criteria were evaluated

\- required validation was performed

\- evidence status was recorded

\- blockers were resolved or explicitly accepted



Completion does not imply deployment or production readiness.



\## Approval State



Approval State represents authorization for one controlled action.



\### Approval State Values



\- NOT REQUIRED

\- PENDING

\- APPROVED

\- REJECTED

\- EXPIRED

\- REVOKED



\### Approval Record



An Approval Record must contain:



\- Approval ID

\- Controlled action

\- Requested by

\- Requested from

\- Scope

\- Status

\- Decision timestamp

\- Expiration condition

\- Related project or request

\- Notes



\### Approval Rules



\- silence is not approval

\- approval must have explicit scope

\- approval must not be reused outside its scope

\- expired approval must not permit execution

\- rejected approval blocks the controlled action

\- revoked approval blocks further execution



\## Validation State



Validation State represents the current verification result.



\### Validation State Values



\- NOT STARTED

\- IN PROGRESS

\- VERIFIED

\- PARTIALLY VERIFIED

\- UNVERIFIED

\- CONTRADICTED

\- NOT TESTED

\- REPAIR REQUIRED

\- BLOCKED



\### Validation Rules



\- Validation must evaluate defined acceptance criteria.

\- Validation must reflect available evidence.

\- Failed or blocked validation prevents Delivery.

\- Repair requires re-review and re-validation.

\- Validation does not create execution evidence by itself.



\## Evidence State



Evidence State represents the strongest proof available for a claim or artifact.



\### Evidence State Values



\- PLANNED

\- DESIGNED

\- CREATED

\- STATICALLY VERIFIED

\- EXECUTED

\- INTEGRATION VERIFIED

\- END-TO-END VERIFIED

\- DEPLOYED

\- PRODUCTION VERIFIED

\- UNVERIFIED



\### Evidence Transition Rules



Evidence strength may increase only when stronger observable proof exists.



```text

PLANNED

&#x20;  ↓

DESIGNED

&#x20;  ↓

CREATED

&#x20;  ↓

STATICALLY VERIFIED

&#x20;  ↓

EXECUTED

&#x20;  ↓

INTEGRATION VERIFIED

&#x20;  ↓

END-TO-END VERIFIED

&#x20;  ↓

DEPLOYED

&#x20;  ↓

PRODUCTION VERIFIED

```



Evidence may be downgraded when:



\- proof is missing

\- proof is invalid

\- the environment changed

\- execution cannot be reproduced

\- validation identifies contradiction

\- deployment or production status can no longer be confirmed



Model agreement is not execution evidence.



Artifact existence supports CREATED only.



\## Delivery State



Delivery State represents readiness for user handover.



\### Delivery State Values



\- NOT READY

\- PREPARING

\- BLOCKED

\- READY

\- DELIVERED

\- ACCEPTED

\- REJECTED

\- SUPERSEDED



\### Delivery Readiness Requirements



Delivery may enter READY only when:



\- required artifacts exist

\- required validation permits delivery

\- evidence status is recorded

\- known limitations are documented

\- remaining risks are documented

\- required approvals are available

\- handover information is prepared



Delivery does not imply deployment.



\## Blocking State



Any state domain may enter BLOCKED.



A blocker record must contain:



\- Blocker ID

\- Description

\- Affected state domain

\- Cause

\- Impact

\- Severity

\- Required resolution

\- Owner

\- Status

\- Date identified



\### Blocking Conditions



Typical blocking conditions include:



\- missing required information

\- conflicting requirements

\- missing approval

\- governance violation

\- undefined workflow

\- undefined capability

\- critical security or privacy risk

\- unsupported evidence claim

\- failed validation

\- unavailable required integration



\## Recovery State



Recovery resumes execution from the last valid state.



\### Recovery Rules



When recovering:



1\. preserve the blocking record

2\. confirm the blocker is resolved

3\. confirm updated inputs or approvals

4\. reassess affected risks

5\. restore the last valid state

6\. repeat affected execution steps

7\. repeat affected validation

8\. record the recovery result



Recovery must not erase project history.



\## State Transition Rules



Every transition must define:



\- current state

\- requested next state

\- transition trigger

\- required conditions

\- approval requirements

\- evidence requirements

\- resulting state

\- transition timestamp



Invalid transitions must be rejected.



\### Examples of Invalid Transitions



\- RECEIVED directly to EXECUTING

\- EXECUTING directly to DELIVERED

\- PENDING approval directly to execution

\- BLOCKED directly to COMPLETED

\- CREATED directly to DEPLOYED without evidence

\- NOT TESTED directly to VERIFIED without validation



\## State History



State history is append-only.



The system must preserve:



\- previous state

\- new state

\- transition reason

\- actor or source

\- timestamp

\- associated decision

\- associated approval

\- associated evidence



Historical state records must not be silently deleted or overwritten.



\## Baseline State



An approved baseline must record:



\- Baseline ID

\- Version

\- Scope

\- Requirements

\- Architecture

\- Constraints

\- Approved decisions

\- Approval status

\- Effective date



A baseline may be:



\- DRAFT

\- UNDER REVIEW

\- APPROVED

\- SUPERSEDED

\- ARCHIVED



Only one approved active baseline should exist for one project version.



Changing an approved baseline requires explicit approval and change control.



\## State Ownership



| State Domain | Primary Owner |

|---|---|

| Project State | State Manager |

| Request State | Runtime and State Manager |

| Workflow State | Workflow Manager |

| Task State | Workflow Manager and Capability Manager |

| Approval State | Approval Manager |

| Validation State | Validation Manager |

| Evidence State | Evidence Manager |

| Delivery State | Delivery component |



Core coordinates all state domains.



\## Future SaaS Persistence



The future SaaS implementation should persist:



\- organizations

\- users

\- projects

\- baselines

\- requests

\- workflows

\- tasks

\- decisions

\- approvals

\- risks

\- blockers

\- assumptions

\- evidence

\- artifacts

\- deliveries

\- state transitions



This document does not define the database schema.



\## Prohibited State Behavior



The system must never:



\- skip mandatory states

\- fabricate state transitions

\- mark work complete without evidence

\- erase state history silently

\- infer approval from silence

\- modify approved baselines without approval

\- mark Delivery ready after failed validation

\- mark deployment or production status without evidence

\- recover from a blocker without confirming resolution



\## Out of Scope



This document does not define:



\- database tables

\- event-bus implementation

\- API endpoints

\- queue infrastructure

\- storage technology

\- distributed transaction design

\- SaaS user-interface behavior



These require dedicated implementation specifications.



\## Acceptance Criteria



This document is acceptable when:



\- all official state domains are defined

\- valid state values are documented

\- transition rules are explicit

\- blockers and recovery are modeled

\- approval, validation, and evidence states are separated

\- state history is preserved

\- baseline state is protected

\- delivery readiness depends on validation

\- invalid transitions are prohibited

\- future SaaS persistence needs are identified without defining implementation



\## Evidence Status



\*\*Document created:\*\* CREATED



\*\*Static review:\*\* NOT TESTED



\*\*Repository validation:\*\* UNVERIFIED



\*\*State implementation:\*\* UNVERIFIED



\*\*Persistence implementation:\*\* NOT IMPLEMENTED



\*\*Runtime testing:\*\* NOT TESTED

