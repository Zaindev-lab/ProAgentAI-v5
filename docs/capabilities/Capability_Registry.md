# Capability Registry

**Document ID:** CAP-REG-001

**Version:** 5.0.0-alpha

**Status:** Draft

**Owner:** Product Owner

**Category:** Capability

**Depends on:**

- `docs/governance/Documentation_Standard.md`
- `docs/core/Knowledge_Model.md`
- `docs/architecture/Capability_Architecture.md`

**Referenced by:**

- future capability specifications
- future workflow registry
- future Runtime capability selection
- future SaaS Capability Service

**Last Updated:** 2026-08-05

## Purpose

This document is the authoritative registry of all production capabilities supported by ProAgentAI v5.

It records capability identifiers, names, categories, versions, owners, lifecycle status, and specification paths.

A capability is not part of the production baseline unless it is registered here and has an approved specification.

## Registry Principles

Every production capability must:

- have a unique immutable Capability ID
- belong to one primary category
- define one primary responsibility
- reference one specification document
- define its owner
- define its version
- define its lifecycle status
- define its validation requirements
- define its evidence expectations

Capabilities must not be invented during execution.

Runtime and Workflows may use only capabilities registered in this document.

## Capability Categories

| Category | Directory |
|---|---|
| Analysis | `docs/capabilities/analysis/` |
| Requirements | `docs/capabilities/requirements/` |
| Planning | `docs/capabilities/planning/` |
| Architecture | `docs/capabilities/architecture/` |
| Design | `docs/capabilities/design/` |
| Documentation | `docs/capabilities/documentation/` |
| Review | `docs/capabilities/review/` |
| Validation | `docs/capabilities/validation/` |
| Security | `docs/capabilities/security/` |
| Privacy | `docs/capabilities/privacy/` |
| Cost | `docs/capabilities/cost/` |
| Migration | `docs/capabilities/migration/` |
| Delivery | `docs/capabilities/delivery/` |
| Runtime | `docs/capabilities/runtime/` |
| Governance | `docs/capabilities/governance/` |

## Capability Identifier Format

Capability identifiers use the format:

```text
CAP-001
CAP-002
CAP-003
```

Capability IDs are immutable and must never be reused.

## Lifecycle Status Values

Allowed values are:

- Draft
- Review
- Approved
- Deprecated
- Archived

## Registry

| Capability ID | Name | Category | Version | Status | Owner | Specification |
|---|---|---|---|---|---|---|
| CAP-001 | Project Intake | Analysis | 5.0.0-alpha | Draft | Product Owner | `docs/capabilities/analysis/CAP-001_Project_Intake.md` |
| CAP-002 | Requirements Analysis | Requirements | 5.0.0-alpha | Draft | Product Owner | `docs/capabilities/requirements/CAP-002_Requirements_Analysis.md` |
| CAP-003 | Scope Definition | Planning | 5.0.0-alpha | Draft | Product Owner | `docs/capabilities/planning/CAP-003_Scope_Definition.md` |
| CAP-004 | Risk Identification | Analysis | 5.0.0-alpha | Draft | Product Owner | `docs/capabilities/analysis/CAP-004_Risk_Identification.md` |

## Category Counts

| Category | Count |
|---|---:|
| Analysis | 2 |
| Requirements | 1 |
| Planning | 1 |
| Architecture | 0 |
| Design | 0 |
| Documentation | 0 |
| Review | 0 |
| Validation | 0 |
| Security | 0 |
| Privacy | 0 |
| Cost | 0 |
| Migration | 0 |
| Delivery | 0 |
| Runtime | 0 |
| Governance | 0 |

## Registration Rules

A capability may be registered only when:

- its identifier is unique
- its category exists
- its specification path is defined
- its responsibility is distinct
- its owner is identified
- its version is defined
- its status is valid
- its dependencies are documented
- its validation requirements are documented

## Change Rules

Changes to a registered capability require:

1. change rationale
2. impact review
3. dependency review
4. version update
5. specification update
6. registry update
7. regression review

## Prohibited Registry Behavior

The registry must never:

- reuse Capability IDs
- register duplicate responsibilities
- reference archived specifications as production capabilities
- mark an unimplemented capability as executed
- hide deprecated capabilities
- permit unregistered capabilities in production workflows

## Acceptance Criteria

This registry is acceptable when:

- every capability ID is unique
- every registered capability has a specification path
- categories match the directory structure
- lifecycle statuses use approved values
- category counts match registered entries
- archived capability drafts are excluded from the production registry

## Evidence Status

**Document created:** CREATED

**Static review:** NOT TESTED

**Repository validation:** UNVERIFIED

**Registered capability count:** 1

**Implemented capability count:** 0

**Production capability execution:** NOT TESTED
