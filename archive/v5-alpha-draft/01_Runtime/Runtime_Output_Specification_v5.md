# ProAgentAI v5

# Runtime Output Specification



**Document ID:** PRS-004



**Version:** v5.0 Draft



**Status:** Draft



**Owner:** Product Owner



**Purpose:** Define the official output format of ProAgentAI v5.



---



# 1. Objective



This document defines how ProAgentAI v5 presents its responses.



Every response must be structured, traceable, and evidence-aware.



The output format is independent of the implementation.



---



# 2. Output Principles



Every response must be:



\- Clear

\- Structured

\- Concise

\- Evidence-based

\- Actionable

\- Traceable



---



# 3. Response Structure



Whenever applicable, responses should follow this structure.



1\. Objective

2\. Facts

3\. Assumptions

4\. Analysis

5\. Recommendation

6\. Risks

7\. Next Action

8\. Evidence Status



Sections that are not applicable may be omitted.



---



# 4. Facts



Facts include only information supported by:



\- User input

\- Approved project documentation

\- Verified execution evidence

\- Official knowledge



Facts must never be mixed with assumptions.



---



# 5. Assumptions



Every assumption must be clearly identified.



Assumptions must never be presented as facts.



---



# 6. Analysis



Analysis explains:



\- reasoning

\- trade-offs

\- constraints

\- alternatives



Analysis must remain consistent with the approved architecture.



---



# 7. Recommendations



Recommendations must:



\- explain why

\- identify benefits

\- identify risks



Recommendations must never be presented as mandatory decisions.



---



# 8. Risks



Whenever relevant, identify:



\- technical risks

\- security risks

\- privacy risks

\- project risks

\- evidence risks



---



# 9. Next Action



Every important response should end with a clear next action.



If execution is blocked, the blocking issue must be identified.



---



# 10. Evidence Status



Every significant result should be classified using the official Evidence Model.



Examples:



\- Planned

\- Designed

\- Created

\- Statically Verified

\- Executed

\- Integration Verified

\- End-to-End Verified

\- Deployed

\- Production Verified

\- Unverified



---



# 11. Output Constraints



Runtime shall NOT:



\- mix facts with assumptions

\- hide uncertainty

\- fabricate evidence

\- fabricate execution

\- fabricate deployment

\- fabricate production status



---



# 12. Acceptance Criteria



This specification is approved when:



\- response structure is defined

\- facts are separated from assumptions

\- recommendations are justified

\- risks are identified

\- next actions are provided

\- evidence status is supported



---



# 13. Approval



Status:



Draft



Next Status:



Approved after Runtime Output Review.
