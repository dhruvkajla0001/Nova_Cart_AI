# NovaCart AI --- AI Pipeline

> **From enterprise activity to AI opportunity, Llama reasoning, and
> workforce impact**

This document explains the AI intelligence pipeline implemented in
NovaCart AI.

The central design principle is:

``` text
Structured enterprise facts
        ↓
Deterministic intelligence
        ↓
AI opportunity
        ↓
Local Llama reasoning
        ↓
Workforce impact cascade
        ↓
Frontend intelligence
```

The platform does not ask the LLM to discover the enterprise graph from
scratch. PostgreSQL provides verified graph context, application logic
performs structured assessment, and Llama 3.2 explains the resulting
transformation in natural language.

------------------------------------------------------------------------

# 1. Pipeline Overview

NovaCart AI processes an enterprise activity through several
intelligence stages.

``` text
┌─────────────────────┐
│ Enterprise Activity │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ Activity Classifier │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ AI Analyzer         │
│ Automation          │
│ Augmentation        │
│ AI Mode             │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ AI Opportunity      │
│ Technology          │
│ AI Type             │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ Graph Context       │
│ Roles               │
│ Skills              │
│ Process              │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ Llama 3.2           │
│ Runtime Reasoning   │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ Impact Service      │
│ Workforce Cascade   │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ React Dashboard     │
└─────────────────────┘
```

------------------------------------------------------------------------

# 2. Why the Pipeline Is Layered

A single LLM call is not sufficient for an enterprise workforce
intelligence system.

An LLM can generate a convincing explanation, but it should not be
treated as the authoritative source for:

-   Enterprise relationships
-   Activity IDs
-   Role IDs
-   Skill IDs
-   Process relationships
-   Stored AI opportunities
-   Impact records

NovaCart therefore uses a layered approach.

``` text
DATABASE
  = What exists?

DETERMINISTIC AI
  = What can be measured?

LLM
  = Why does the assessment make sense?

IMPACT ENGINE
  = What can happen to connected work and workforce?
```

This separation makes the system easier to reason about and test.

------------------------------------------------------------------------

# 3. Stage 1 --- Enterprise Activity

Everything starts with an enterprise activity.

An activity contains information such as:

``` text
activity_id
activity_code
name
description
activity_type
sequence_order
process_id
```

Example:

``` text
Name:
Track conversion funnel

Description:
Monitor customer movement from prospect
to completed purchase.

Type:
ANALYSIS
```

The activity is associated with an enterprise process through
PostgreSQL.

------------------------------------------------------------------------

# 4. Stage 2 --- Activity Classification

The `ActivityClassifier` performs deterministic classification.

The classifier evaluates the activity and produces a structured result.

Example:

``` json
{
  "category": "ANALYSIS",
  "confidence": 0.9,
  "scores": {
    "ANALYSIS": 6,
    "DECISION": 0,
    "CONTENT": 0,
    "CUSTOMER_INTERACTION": 0,
    "PLANNING": 0,
    "OPERATIONS": 0,
    "PHYSICAL_OPERATION": 1,
    "ADMINISTRATION": 0,
    "FINANCIAL": 0,
    "RISK_COMPLIANCE": 0,
    "TECHNICAL": 0,
    "OTHER": 0
  },
  "matched_keywords": [
    "analysis",
    "monitor",
    "track"
  ]
}
```

The classifier is deterministic application logic.

It does not require Llama to produce the category.

------------------------------------------------------------------------

# 5. Classification Categories

The current classifier can reason across categories including:

``` text
ANALYSIS
DECISION
CONTENT
CUSTOMER_INTERACTION
PLANNING
OPERATIONS
PHYSICAL_OPERATION
ADMINISTRATION
FINANCIAL
RISK_COMPLIANCE
TECHNICAL
OTHER
```

The category provides context for the downstream AI assessment.

------------------------------------------------------------------------

# 6. Classification Confidence

The classifier also returns confidence.

For example:

``` text
Category:
ANALYSIS

Confidence:
90%
```

The confidence is part of the structured intelligence response and is
shown in the frontend.

------------------------------------------------------------------------

# 7. Stage 3 --- AI Assessment

After classification, `AIAnalyzer` evaluates how AI could transform the
activity.

The assessment contains:

``` text
Automation Score
Augmentation Score
AI Mode
Confidence
```

Example:

``` json
{
  "automation_score": 81,
  "augmentation_score": 95,
  "ai_mode": "HIGH_AUTOMATION",
  "confidence": 0.98
}
```

------------------------------------------------------------------------

# 8. Automation Score

The automation score represents the estimated potential for AI-driven
automation of the activity.

Example:

``` text
Automation
81%
```

This does not mean that 81% of a person's job disappears.

It is an activity-level AI transformation signal.

------------------------------------------------------------------------

# 9. Augmentation Score

The augmentation score represents the potential for AI to enhance human
performance.

Example:

``` text
Augmentation
95%
```

This is important because many enterprise activities are better
understood as:

``` text
Human + AI
```

rather than:

``` text
AI replaces human
```

------------------------------------------------------------------------

# 10. AI Mode

The analyzer maps the assessment into an AI transformation mode.

Example:

``` text
HIGH_AUTOMATION
```

Other modes can be represented by the application's assessment logic
depending on the activity.

The mode provides a higher-level interpretation of the numerical scores.

------------------------------------------------------------------------

# 11. Assessment Confidence

The structured AI assessment also has its own confidence.

Example:

``` text
Confidence
98%
```

This is separate from the activity classification confidence.

Therefore the pipeline maintains distinct concepts:

``` text
Classification confidence
        ≠
AI assessment confidence
        ≠
LLM reasoning confidence
```

------------------------------------------------------------------------

# 12. Stage 4 --- AI Opportunity

Once the activity has been assessed, NovaCart resolves the AI
opportunity associated with the activity.

An opportunity contains information such as:

``` text
ai_opportunity_id
name
description
ai_type
technology
automation_score
augmentation_score
confidence_score
status
```

Example:

``` text
AI Opportunity:
AI Automation for Track conversion funnel

AI Type:
INTELLIGENT_AUTOMATION

Technology:
Machine Learning + Analytics
```

------------------------------------------------------------------------

# 13. Why Persist AI Opportunities?

AI opportunities are stored rather than requiring every frontend request
to regenerate the entire assessment.

This allows the system to:

-   Reuse existing intelligence
-   Query opportunities directly
-   Build impact relationships
-   Display stored analysis
-   Maintain a persistent enterprise intelligence layer

Conceptually:

``` text
Activity
   │
   └──────► AI Opportunity
```

------------------------------------------------------------------------

# 14. Stage 5 --- Graph Context

The AI pipeline then retrieves verified enterprise context.

The context can include:

``` text
Process
Roles
Skills
Activity relationships
AI opportunities
Impact information
```

Example:

``` text
Activity
  │
  ├── Process
  │
  ├── Roles
  │
  └── Skills
```

This information comes from PostgreSQL through the repository/service
layer.

------------------------------------------------------------------------

# 15. Role Context

For an activity such as:

``` text
Track conversion funnel
```

the graph can return roles such as:

``` text
Customer Acquisition Analyst
Marketing Manager
```

The role information can include:

``` text
role_id
role_code
name
description
seniority_level
```

This context is provided to downstream analysis.

------------------------------------------------------------------------

# 16. Skill Context

The graph can also return skills connected to the activity.

Example:

``` text
Data Analysis
Marketing Analytics
```

Skill context can include:

``` text
skill_id
skill_code
name
description
category
skill_type
```

This lets the LLM reason about how the transformation affects
capabilities rather than only job titles.

------------------------------------------------------------------------

# 17. Stage 6 --- Local Llama Reasoning

The `LlamaReasoner` receives structured context and generates
natural-language reasoning.

The current runtime uses:

``` text
Ollama
   ↓
Llama 3.2
```

The reasoning layer is downstream from the structured AI assessment.

------------------------------------------------------------------------

# 18. Llama Input Context

The reasoner can receive:

``` text
Activity
Classification
AI Assessment
AI Opportunities
Roles
Skills
Cascade Summary
```

Conceptually:

``` text
                  Activity
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
Classification   Assessment   Graph Context
        │            │            │
        └────────────┼────────────┘
                     ▼
                 Llama 3.2
```

------------------------------------------------------------------------

# 19. Llama Output

A successful reasoning response contains structured reasoning fields.

Typical sections include:

``` text
summary
automation_reasoning
augmentation_reasoning
human_role
skill_change
future_outlook
confidence
```

Example:

``` json
{
  "summary": "...",
  "automation_reasoning": "...",
  "augmentation_reasoning": "...",
  "human_role": "...",
  "skill_change": "...",
  "future_outlook": "...",
  "confidence": 0.8
}
```

The frontend renders these as separate reasoning cards.

------------------------------------------------------------------------

# 20. Executive Summary

The summary gives a concise explanation of the transformation.

For example:

``` text
AI can assist the activity by identifying patterns
and providing insights, while human judgment remains
important for interpretation and decisions.
```

The exact reasoning depends on the selected activity.

------------------------------------------------------------------------

# 21. Automation Reasoning

This section explains why AI can or cannot automate parts of the
activity.

It may identify:

-   Data analysis
-   Pattern recognition
-   Reporting
-   Routine processing
-   Predictive tasks

while identifying where human judgment remains necessary.

------------------------------------------------------------------------

# 22. Augmentation Reasoning

This section explains how AI can support a human worker.

Examples include:

``` text
Data-driven insights
Trend detection
Recommendations
Anomaly detection
Decision support
```

The purpose is to describe AI as an augmentation layer where
appropriate.

------------------------------------------------------------------------

# 23. Human Role

The LLM explains what human involvement should remain.

For example:

``` text
Human workers continue to interpret results,
provide business context, make strategic decisions,
and oversee AI-generated recommendations.
```

This is important to the workforce intelligence goal.

------------------------------------------------------------------------

# 24. Skill Change

The reasoning layer can identify how required capabilities may evolve.

For example:

``` text
Traditional:
Manual reporting

Increasing importance:
Data interpretation
AI literacy
Analytical reasoning
Strategic decision-making
```

The generated explanation is contextual rather than being treated as a
database fact.

------------------------------------------------------------------------

# 25. Future Outlook

The future outlook describes how the activity may evolve as AI
capabilities improve.

The system can reason about:

``` text
More automation
More decision support
Changing human responsibilities
Emerging technical skills
Higher-level human judgment
```

This provides a forward-looking component to the analysis.

------------------------------------------------------------------------

# 26. LLM Confidence

The Llama response can contain its own confidence value.

Example:

``` text
Model confidence:
80%
```

This should be interpreted as model-generated reasoning confidence, not
as database certainty.

------------------------------------------------------------------------

# 27. LLM Failure Handling

Ollama may not always be available.

The architecture therefore separates:

``` text
Deterministic AI Assessment
            +
Optional LLM Reasoning
```

If Ollama is unavailable:

``` text
Classification       ✅
AI Assessment        ✅
AI Opportunity       ✅
Graph Context        ✅
Llama Reasoning      ⚠️ unavailable
```

The frontend can still display the structured assessment.

This prevents a local model failure from making the entire application
unusable.

------------------------------------------------------------------------

# 28. Stage 7 --- Impact Cascade

After the activity has been assessed, the impact layer evaluates
downstream workforce implications.

The `ImpactService` works with stored cascade records and graph context.

Conceptually:

``` text
AI Opportunity
      ↓
Impact Service
      ↓
┌─────┼─────┬──────────┬────────────┐
▼     ▼     ▼          ▼            ▼
Direct Roles Skills Related     Future      Future
Impact             Activities   Roles       Skills
```

------------------------------------------------------------------------

# 29. Five-Level Impact Model

The platform organizes cascade intelligence into five conceptual levels.

``` text
LEVEL 1
Direct impact
    ↓
LEVEL 2
Role / activity impact
    ↓
LEVEL 3
Skill impact
    ↓
LEVEL 4
Future role impact
    ↓
LEVEL 5
Future skill impact
```

The actual returned records depend on the selected activity and graph
relationships.

------------------------------------------------------------------------

# 30. Direct Impact

Direct impact connects the selected activity and its AI transformation.

Example:

``` text
Activity
    ↓
AI Opportunity
    ↓
Direct Impact
```

The impact record can store:

``` text
source_activity_id
source_ai_opportunity_id
impact_level
impact_score
reasoning
```

------------------------------------------------------------------------

# 31. Role Impact

Role impacts identify workers or job roles connected to the transformed
activity.

Example:

``` text
Activity:
Investigate suspicious transactions

Role:
Fraud Analyst

Impact:
67%
```

The frontend displays these records under:

``` text
ROLE IMPACT
Roles affected
```

------------------------------------------------------------------------

# 32. Skill Impact

Skill impacts identify capabilities affected by the transformation.

Example:

``` text
Fraud Analysis
Transaction Monitoring
```

A skill impact can include an impact score and reasoning.

The frontend displays these under:

``` text
CAPABILITY IMPACT
Skills affected
```

------------------------------------------------------------------------

# 33. Related Activity Impact

AI transformation can affect other activities.

The cascade can therefore identify related activities beyond the
currently selected activity.

Conceptually:

``` text
Selected Activity
      ↓
Related Activity
      ↓
Potential downstream transformation
```

The frontend displays these under:

``` text
SECONDARY IMPACT
Related activities
```

------------------------------------------------------------------------

# 34. Future Role Impact

The impact engine can represent potential future workforce roles.

Example:

``` text
Existing role
      ↓
AI transformation
      ↓
Emerging / future role
```

Future role records can include reasoning describing why the role may
evolve.

------------------------------------------------------------------------

# 35. Future Skill Impact

Future skills represent capabilities that may become increasingly
important.

Examples can include:

``` text
AI literacy
Data interpretation
Model oversight
Advanced analytics
Strategic judgment
```

The exact future skills depend on the generated cascade records.

------------------------------------------------------------------------

# 36. Impact Score

Cascade records can contain an impact score from:

``` text
0 → 100
```

The score is stored in PostgreSQL and constrained to the valid range.

The frontend presents the score as an impact percentage.

------------------------------------------------------------------------

# 37. Impact Reasoning

Cascade records can contain reasoning.

Example structure:

``` text
Direct impact:
Activity X is affected by AI opportunity Y.
Role Z is exposed to the transformation.
```

This allows the cascade to be more than a list of IDs.

It provides an explanation for why a particular role or skill appears in
the cascade.

------------------------------------------------------------------------

# 38. Runtime Ingestion Pipeline

The full runtime pipeline begins when a user introduces a new activity.

``` text
                NEW ACTIVITY
                     │
                     ▼
                 INGESTION
                     │
                     ▼
               CLASSIFICATION
                     │
                     ▼
                AI ASSESSMENT
                     │
                     ▼
               AI OPPORTUNITY
                     │
                     ▼
               GRAPH CONTEXT
                     │
                     ▼
                Llama 3.2
                     │
                     ▼
               IMPACT CASCADE
                     │
                     ▼
                 RESPONSE
                     │
                     ▼
              REACT DASHBOARD
```

------------------------------------------------------------------------

# 39. Runtime Ingestion Example

Input:

``` json
{
  "process_id": 1,
  "name": "Analyze supplier risk",
  "description": "Evaluate supplier performance, delivery reliability, and commercial risk before contract renewal.",
  "activity_type": "ANALYSIS"
}
```

The platform can return a complete intelligence response containing:

``` text
Created Activity
Classification
AI Assessment
AI Opportunity
Llama Reasoning
Graph Context
```

The activity is then available as part of the runtime enterprise
context.

------------------------------------------------------------------------

# 40. Existing Activity Pipeline

For an existing activity, the platform can retrieve stored intelligence.

``` text
Activity ID
   ↓
Stored AI Analysis
   ↓
Stored / Computed Cascade
   ↓
Runtime Llama Reasoning
   ↓
Frontend
```

This is different from runtime ingestion because the activity already
exists.

------------------------------------------------------------------------

# 41. Complete Example

Consider:

``` text
Track conversion funnel
```

### Classification

``` text
Category:
ANALYSIS

Confidence:
90%
```

### AI Assessment

``` text
Automation:
81%

Augmentation:
95%

Mode:
HIGH_AUTOMATION

Confidence:
98%
```

### AI Opportunity

``` text
Type:
INTELLIGENT_AUTOMATION

Technology:
Machine Learning + Analytics
```

### Llama Reasoning

``` text
Summary
Automation reasoning
Augmentation reasoning
Human role
Skill change
Future outlook
Confidence
```

### Workforce Impact

``` text
Roles
Skills
Related activities
Future roles
Future skills
```

The complete result is then presented in the dashboard.

------------------------------------------------------------------------

# 42. Complete Intelligence Contract

The reasoning endpoint conceptually returns:

``` json
{
  "activity": {},
  "classification": {},
  "analysis": {},
  "llm_reasoning": {},
  "graph_context": {}
}
```

This allows the frontend to render the intelligence sections
independently.

------------------------------------------------------------------------

# 43. Why Deterministic AI Comes Before the LLM

The ordering is intentional.

Instead of:

``` text
Activity
   ↓
LLM
   ↓
Everything
```

NovaCart uses:

``` text
Activity
   ↓
Classification
   ↓
Structured Assessment
   ↓
Graph Context
   ↓
LLM
```

This gives the model structured context before asking it for reasoning.

It also makes the system easier to debug.

------------------------------------------------------------------------

# 44. Why the Graph Comes Before Reasoning

The LLM should know which enterprise entities are actually connected to
the activity.

For example:

``` text
Activity
   ↓
Roles from PostgreSQL
   ↓
Skills from PostgreSQL
   ↓
Llama
```

Without graph context, the model could generate generic role or skill
assumptions.

The current design instead supplies verified application context.

------------------------------------------------------------------------

# 45. Why the Impact Layer Is Separate

The impact cascade has a different responsibility from the LLM.

``` text
AIAnalyzer
    =
AI transformation assessment

LlamaReasoner
    =
Natural-language explanation

ImpactService
    =
Workforce propagation
```

This separation makes each component easier to test and replace.

------------------------------------------------------------------------

# 46. End-to-End Sequence

The complete system can be summarized as:

``` text
┌──────────────────┐
│ User selects     │
│ activity         │
└────────┬─────────┘
         ▼
┌──────────────────┐
│ PostgreSQL graph │
│ context          │
└────────┬─────────┘
         ▼
┌──────────────────┐
│ Classifier       │
└────────┬─────────┘
         ▼
┌──────────────────┐
│ AI Analyzer      │
└────────┬─────────┘
         ▼
┌──────────────────┐
│ AI Opportunity   │
└────────┬─────────┘
         ▼
┌──────────────────┐
│ Llama Reasoner   │
└────────┬─────────┘
         ▼
┌──────────────────┐
│ Impact Service   │
└────────┬─────────┘
         ▼
┌──────────────────┐
│ React Dashboard  │
└──────────────────┘
```

------------------------------------------------------------------------

# 47. Failure Boundaries

Each stage has a clear responsibility.

``` text
Database failure
    ↓
Graph context unavailable

Classifier failure
    ↓
Classification unavailable

Analyzer failure
    ↓
Structured assessment unavailable

Ollama failure
    ↓
LLM reasoning unavailable

Impact failure
    ↓
Cascade unavailable
```

The goal is to prevent failures in one intelligence component from being
incorrectly represented as failures of all other components.

------------------------------------------------------------------------

# 48. Observability Opportunities

The layered pipeline also creates clear places for future observability.

Potential metrics include:

``` text
Classification latency
AI assessment latency
Database query latency
Llama latency
Impact cascade latency
Total pipeline latency
LLM availability
Pipeline success rate
```

These are future production enhancements rather than assumptions about
the current implementation.

------------------------------------------------------------------------

# 49. Evaluation Strategy

Each intelligence layer can be evaluated independently.

### Classifier

Evaluate:

``` text
Correct category
Confidence calibration
Keyword matching
```

### AI Analyzer

Evaluate:

``` text
Score consistency
AI mode consistency
Opportunity selection
```

### Llama

Evaluate:

``` text
Reasoning relevance
Context adherence
Structured output validity
Consistency
```

### Impact Engine

Evaluate:

``` text
Correct relationships
Impact score validity
Cascade completeness
```

This modular evaluation strategy is preferable to treating the whole
system as one opaque AI model.

------------------------------------------------------------------------

# 50. Recruiter / Interview Explanation

A concise explanation of the pipeline is:

> "NovaCart AI separates enterprise facts from AI reasoning. PostgreSQL
> is the source of truth for activities, processes, roles, skills, and
> relationships. A deterministic classifier first understands the type
> of work, then an AI analyzer estimates automation and augmentation
> potential and resolves an AI opportunity. That structured context is
> passed to a locally hosted Llama 3.2 model through Ollama to generate
> contextual reasoning. Finally, the ImpactService propagates the
> transformation through roles, skills, related activities, and future
> workforce capabilities, which are visualized in React."

------------------------------------------------------------------------

# 51. Key Design Takeaway

The NovaCart AI pipeline is not simply:

``` text
Prompt → LLM → Answer
```

It is:

``` text
Enterprise Data
      ↓
Structured Context
      ↓
Deterministic Intelligence
      ↓
AI Opportunity
      ↓
Generative Reasoning
      ↓
Workforce Impact
      ↓
Actionable Visualization
```

This is the core intelligence architecture of NovaCart AI.

------------------------------------------------------------------------

# 52. Summary

NovaCart AI combines several forms of intelligence:

``` text
DATABASE INTELLIGENCE
        +
DETERMINISTIC AI
        +
GENERATIVE AI
        +
GRAPH-BASED IMPACT ANALYSIS
        =
WORKFORCE INTELLIGENCE
```

The architecture is designed so that:

-   PostgreSQL establishes enterprise facts.
-   The classifier categorizes work.
-   The analyzer quantifies AI transformation potential.
-   AI opportunities persist transformation candidates.
-   Llama 3.2 explains the assessment.
-   ImpactService traces workforce consequences.
-   React presents the complete intelligence story.

The resulting pipeline transforms a single enterprise activity into a
structured view of **AI opportunity, human augmentation, and workforce
change**.
