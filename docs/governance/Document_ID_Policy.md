# Document ID Policy

**Document ID:** GOV-003

**Version:** 5.0.0-alpha

**Status:** Draft

**Owner:** Product Owner

**Category:** Governance

**Depends on:**

- `docs/governance/Documentation_Standard.md`
- `docs/governance/Baseline_Governance.md`

**Referenced by:**

- all production documentation
- documentation validation scripts
- future document registry

**Last Updated:** 2026-08-05

## Purpose

This document defines the official identifier policy for ProAgentAI v5 production documents.

Document identifiers provide uniqueness, traceability, stable references, and lifecycle control.

## Core Rules

Every production document must:

- have exactly one Document ID
- use a unique identifier across the repository
- preserve its identifier throughout its lifecycle
- never reuse an identifier assigned to another document
- retain its identifier after deprecation or archival

## Identifier Format

The standard format is:

```text
PREFIX-001
```

Compound prefixes may be used when required:

```text
CAP-REG-001
WF-REG-001
RUNTIME-INDEX-001
ARCH-INDEX-001
TEMPLATE-CAP-001
```

The numeric portion must contain at least three digits.

## Approved Prefixes

| Prefix | Purpose |
|---|---|
| CORE | Core reference models |
| ARCH | Architecture documents |
| RT | Runtime specifications |
| RUNTIME-INDEX | Runtime indexes |
| ARCH-INDEX | Architecture indexes |
| CAP | Capability specifications |
| CAP-REG | Capability registries |
| WF | Workflow specifications |
| WF-REG | Workflow registries |
| GOV | Governance policies |
| SEC | Security documents |
| VAL | Validation documents |
| REL | Release documents |
| ADR | Architecture Decision Records |
| TEMPLATE | General templates |
| TEMPLATE-CAP | Capability templates |

New prefixes require governance review.

## Allocation Rules

Identifiers must be allocated sequentially within their prefix.

Before assigning an identifier:

1. search all production documents
2. confirm the identifier is unused
3. confirm the prefix matches the document category
4. record the identifier in the relevant registry when applicable

## Immutability

After a document is committed to Git, its Document ID should not change.

An identifier change is permitted only when correcting a verified allocation error before approval.

Approved documents require change control before identifier modification.

## Deprecated and Archived Documents

Deprecated and archived identifiers remain reserved.

They must never be reassigned to new documents.

## Duplicate Identifiers

A duplicate Document ID is a validation failure.

When a duplicate is found:

1. preserve the identifier of the earliest authoritative document
2. assign the next available identifier to the newer document
3. update dependencies and references
4. rerun repository validation

## Validation Requirements

Automated validation must verify:

- every production Markdown document contains a Document ID
- each identifier is unique
- each identifier uses a valid format
- archived documents are excluded from production uniqueness checks unless explicitly requested

## Prohibited Behavior

The project must never:

- reuse an archived identifier
- assign one identifier to multiple production documents
- silently change approved identifiers
- use temporary identifiers in released documents
- infer identifier uniqueness without repository validation

## Acceptance Criteria

This policy is acceptable when:

- identifier formats are defined
- approved prefixes are documented
- allocation and immutability rules are explicit
- duplicate handling is defined
- automated validation requirements are defined

## Evidence Status

**Document created:** CREATED

**Static review:** NOT TESTED

**Repository validation:** UNVERIFIED

**Policy enforcement:** PARTIALLY IMPLEMENTED
