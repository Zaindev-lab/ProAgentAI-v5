\# Workflow Registry



\*\*Document ID:\*\* WF-REG-001



\*\*Version:\*\* 5.0.0-alpha



\*\*Status:\*\* Draft



\*\*Owner:\*\* Product Owner



\*\*Category:\*\* Workflow Registry



\*\*Depends on:\*\*



\- `docs/architecture/Capability\_Architecture.md`

\- `docs/capabilities/Capability\_Registry.md`



\*\*Last Updated:\*\* 2026-08-05



\---



\# Purpose



This document is the authoritative registry of production workflows supported by ProAgentAI v5.



Workflows orchestrate capabilities.



Runtime selects workflows.



Capabilities execute work.



\---



\# Initial Workflow Registry



| Workflow ID | Name | Status | Specification |

|---|---|---|---|

| WF-001 | Standard Project Delivery | Draft | `docs/workflows/analysis/WF-001\_Standard\_Project\_Delivery.md` |



\---



\# Workflow Identifier Format



```text

WF-001

WF-002

WF-003

```



Identifiers are immutable.



\---



\# Acceptance Criteria



\- workflow identifiers are unique

\- referenced specifications exist

\- workflows reference registered capabilities only



\---



\# Evidence Status



\*\*Document created:\*\* CREATED



\*\*Static review:\*\* NOT TESTED



\*\*Workflow count:\*\* 1

