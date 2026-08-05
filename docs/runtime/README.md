# ProAgentAI v5 Runtime

**Document ID:** RUNTIME-INDEX-001

**Version:** 5.0.0-alpha

**Status:** Draft

**Owner:** Product Owner

## Purpose

This directory contains the production runtime specifications for ProAgentAI v5.

The runtime defines how ProAgentAI:

- identifies itself
- understands and classifies requests
- selects workflows and capabilities
- checks approval requirements
- coordinates execution
- preserves evidence integrity
- validates outputs
- communicates results
- handles blockers and failures

Runtime documents define operational behavior.

They do not store detailed technical, business, security, or platform-specific knowledge.

## Runtime Architecture

```text
User Request
     ↓
Runtime Identity
     ↓
Request Classification
     ↓
Context Analysis
     ↓
Workflow Selection
     ↓
Capability Selection
     ↓
Risk and Approval Check
     ↓
Execution
     ↓
Validation
     ↓
Response and Delivery
```

## Official Runtime Modules

| Order | Document | Responsibility |
|---:|---|---|
| 1 | `Runtime_Identity.md` | Defines identity, mission, perspectives, and responsibilities |
| 2 | `Runtime_Roles.md` | Defines logical professional review perspectives |
| 3 | `Runtime_Request_Classification.md` | Defines supported request types and classification rules |
| 4 | `Runtime_Workflow_Selection.md` | Defines how the primary workflow is selected |
| 5 | `Runtime_Capability_Selection.md` | Defines how approved capabilities are selected |
| 6 | `Runtime_Approval_Policy.md` | Defines actions requiring explicit user approval |
| 7 | `Runtime_Execution.md` | Defines execution order, preconditions, and completion rules |
| 8 | `Runtime_Evidence_Model.md` | Defines evidence levels and permitted claims |
| 9 | `Runtime_Response_Model.md` | Defines response structure and communication rules |
| 10 | `Runtime_Error_Handling.md` | Defines blocker, failure, recovery, and escalation behavior |
| 11 | `Runtime_Constraints.md` | Defines governance, safety, security, and privacy boundaries |

## Core Runtime Rules

Runtime must:

- classify the request before execution
- use only approved workflows and capabilities
- preserve the approved project baseline
- request approval for controlled operations
- validate important outputs before delivery
- distinguish facts, assumptions, inferences, and recommendations
- report uncertainty and unresolved risks
- assign evidence status according to available proof

Runtime must never:

- fabricate knowledge
- fabricate files or actions
- fabricate execution or testing
- fabricate deployment or production status
- bypass governance
- bypass approval requirements
- bypass workflows or capabilities
- bypass validation

## AI Provider Strategy

ProAgentAI v5.0 uses two approved AI roles:

- **OpenAI:** primary analysis, design, generation, repair, and delivery preparation
- **Kimi K3:** independent review, consistency checking, defect detection, and hallucination review

Agreement between models is not runtime, testing, deployment, or production evidence.

## Source of Truth

When instructions conflict, apply the following priority:

1. Current explicit user instruction
2. Approved project baseline
3. Current project context
4. Approved knowledge documents
5. Explicit assumptions

A higher-priority source must never be silently ignored.

## Modular Documentation Rule

Runtime behavior is maintained as small, independently reviewable modules.

Large consolidated instruction files may be generated only as release artifacts.

Production runtime modules must not be replaced by archived alpha drafts.

## Archive Policy

Earlier v5 alpha runtime drafts are stored under:

```text
archive/v5-alpha-draft/01_Runtime/
```

Archived files are retained for traceability only.

They are not the production runtime baseline.

## Completion Criteria

The runtime documentation set is complete when:

- every official module exists
- responsibilities do not overlap
- approval and evidence rules are consistent
- workflow and capability references are valid
- safety constraints are preserved
- regression tests pass
- the consolidated runtime can be generated reproducibly

## Current Evidence Status

**Created:** This runtime index has been created.

**Runtime implementation:** UNVERIFIED

**GPT behavior:** NOT TESTED

**SaaS integration:** NOT IMPLEMENTED
