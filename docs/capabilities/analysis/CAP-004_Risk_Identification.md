\# Risk Identification



\*\*Document ID:\*\* CAP-004



\*\*Version:\*\* 5.0.0-alpha



\*\*Status:\*\* Draft



\*\*Owner:\*\* Product Owner



\*\*Category:\*\* Analysis



\*\*Depends on:\*\*



\- `docs/capabilities/analysis/CAP-001\_Project\_Intake.md`

\- `docs/capabilities/requirements/CAP-002\_Requirements\_Analysis.md`

\- `docs/capabilities/planning/CAP-003\_Scope\_Definition.md`



\*\*Referenced by:\*\*



\- Architecture Design

\- Delivery Planning

\- Validation Planning



\*\*Last Updated:\*\* 2026-08-05



\---



\# Purpose



Risk Identification systematically identifies project risks before architecture, implementation, or delivery activities begin.



The objective is to expose uncertainty early and improve planning decisions.



\---



\# Objective



The capability shall:



\- identify technical risks

\- identify business risks

\- identify schedule risks

\- identify resource risks

\- identify security risks

\- identify privacy risks

\- identify operational risks

\- classify risks

\- prioritize risks

\- recommend mitigations



\---



\# Inputs



Required:



\- Project Intake

\- Requirements Analysis

\- Scope Definition



Optional:



\- architecture documents

\- stakeholder feedback

\- historical project data



\---



\# Outputs



The capability produces:



\- Risk Register

\- Risk Categories

\- Risk Priorities

\- Probability Assessment

\- Impact Assessment

\- Mitigation Recommendations

\- Residual Risks



\---



\# Standard Output



```text

Risk Register



Technical Risks



Business Risks



Security Risks



Privacy Risks



Operational Risks



Probability



Impact



Priority



Mitigation



Residual Risk

```



\---



\# Preconditions



Execution requires:



\- completed Scope Definition

\- identified project objectives



\---



\# Postconditions



Upon completion:



\- risks are documented

\- priorities are assigned

\- mitigation actions are proposed



\---



\# Validation



Validation checks:



\- duplicate risk detection

\- missing categories

\- consistency with project scope

\- mitigation completeness



\---



\# Acceptance Criteria



The capability is successful when:



\- major risks are identified

\- categories are complete

\- priorities are assigned

\- mitigations are documented



\---



\# Failure Conditions



Execution fails when:



\- project scope is unavailable

\- project objectives are undefined

\- insufficient project information exists



\---



\# Limitations



This capability does not:



\- eliminate risks

\- approve mitigations

\- perform security audits

\- replace formal risk management



\---



\# Future SaaS Mapping



Future fields may include:



\- risk\_id

\- project\_id

\- category

\- probability

\- impact

\- priority

\- mitigation

\- owner

\- status



\---



\# Prohibited Behavior



This capability must never:



\- fabricate risks

\- hide known risks

\- assign false evidence

\- claim mitigation effectiveness without validation



\---



\# Evidence Status



\*\*Document created:\*\* CREATED



\*\*Static review:\*\* NOT TESTED



\*\*Implementation:\*\* NOT IMPLEMENTED



\*\*Runtime execution:\*\* UNVERIFIED

