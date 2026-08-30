# NovaCart AI --- Architecture

> **Enterprise AI Workforce Intelligence Platform**

This document describes the architecture of NovaCart AI as implemented
in the current project.

The platform connects enterprise graph data, deterministic AI
assessment, local LLM reasoning, workforce impact analysis, and a React
dashboard into one end-to-end intelligence pipeline.

------------------------------------------------------------------------

## 1. Architecture at a Glance

``` text
┌──────────────────────────────────────────────────────────────┐
│                        React Frontend                        │
│                                                              │
│  Enterprise Graph Explorer                                   │
│  AI Assessment                                               │
│  Llama Reasoning                                             │
│  AI Impact Cascade                                          │
│  Runtime Activity Ingestion                                 │
└────────────────────────────┬─────────────────────────────────┘
                             │ REST / JSON
                             ▼
┌──────────────────────────────────────────────────────────────┐
│                         FastAPI API                           │
│                                                              │
│  /industries        /processes        /activities            │
│  /graph             /ai-analysis      /ingestion             │
└───────────────┬───────────────────┬──────────────────────────┘
                │                   │
                ▼                   ▼
┌─────────────────────────┐   ┌────────────────────────────────┐
│   Graph / Data Layer    │   │       AI Intelligence Layer    │
│                         │   │                                │
│ SQLAlchemy              │   │ ActivityClassifier             │
│ GraphRepository         │   │ AIAnalyzer                      │
│ GraphService            │   │ LlamaReasoner                   │
│ PostgreSQL              │   │                                │
└────────────┬────────────┘   └───────────────┬────────────────┘
             │                                │
             │                                ▼
             │                     ┌──────────────────────────┐
             │                     │   Ollama / Llama 3.2     │
             │                     │   Local runtime reasoning │
             │                     └──────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────────────────────────┐
│                     Impact Intelligence                       │
│                                                              │
│ ImpactService                                                │
│ AI Impact Cascade                                            │
│ Roles → Skills → Activities → Future Roles → Future Skills  │
└──────────────────────────────────────────────────────────────┘
```

------------------------------------------------------------------------

# 2. Core Architectural Principle

NovaCart AI intentionally separates **enterprise facts**,
**deterministic intelligence**, and **generative reasoning**.

``` text
                  ENTERPRISE FACTS
                         │
                         ▼
                   PostgreSQL
                         │
                         ▼
               Deterministic Analysis
                         │
                         ▼
                 AI Opportunity
                         │
                         ▼
                  Local LLM Reasoning
                         │
                         ▼
                 Workforce Impact
```

### PostgreSQL

PostgreSQL is the source of truth for:

-   Industries
-   Value chains
-   Processes
-   Activities
-   Roles
-   Skills
-   Relationships
-   AI opportunities
-   Impact cascade records
-   Runtime records

### Deterministic AI

Application logic handles structured decisions such as:

-   Activity classification
-   Classification confidence
-   Automation score
-   Augmentation score
-   AI mode
-   Opportunity selection
-   Impact scoring

### Llama 3.2

The local Llama model is responsible for contextual natural-language
reasoning.

It explains:

-   Why automation is possible
-   How AI augments humans
-   What human involvement remains
-   How skills may change
-   What the future role of humans may look like

The LLM does not replace the enterprise graph.

------------------------------------------------------------------------

# 3. Layered Architecture

NovaCart AI is organized into the following logical layers:

``` text
┌──────────────────────────────────────┐
│ Presentation Layer                   │
│ React + CSS                          │
└──────────────────┬───────────────────┘
                   │
┌──────────────────▼───────────────────┐
│ API Layer                            │
│ FastAPI Routes                       │
└──────────────────┬───────────────────┘
                   │
┌──────────────────▼───────────────────┐
│ Service Layer                        │
│ GraphService                         │
│ ImpactService                        │
│ IngestionService                     │
└─────────────┬───────────────┬────────┘
              │               │
              ▼               ▼
┌─────────────────────┐ ┌─────────────────────┐
│ Data Access Layer   │ │ AI Intelligence     │
│                     │ │                     │
│ Repositories        │ │ Classifier          │
│ SQLAlchemy          │ │ AI Analyzer         │
│                     │ │ Llama Reasoner      │
└──────────┬──────────┘ └──────────┬──────────┘
           │                       │
           ▼                       ▼
     PostgreSQL                 Ollama
```

------------------------------------------------------------------------

# 4. Frontend Architecture

The frontend is a React application centered around the main dashboard.

Current implementation uses:

``` text
frontend/
└── src/
    ├── App.jsx
    ├── App.css
    └── index.css
```

The current `App.jsx` manages the primary dashboard experience.

It presents:

1.  Enterprise graph navigation
2.  Selected activity
3.  AI assessment
4.  AI opportunity
5.  Llama reasoning
6.  Workforce impact
7.  Runtime activity ingestion

------------------------------------------------------------------------

## 4.1 Frontend State Flow

The selected enterprise activity drives the rest of the dashboard.

``` text
Industry
   ↓
Value Chain
   ↓
Process
   ↓
Activity
   ↓
┌─────────────────────────────┐
│ Selected Activity           │
└─────────────┬───────────────┘
              │
              ├──────────────► AI Analysis
              │
              ├──────────────► Llama Reasoning
              │
              └──────────────► Impact Cascade
```

When the activity changes, the frontend retrieves the corresponding
backend intelligence.

------------------------------------------------------------------------

## 4.2 Frontend Intelligence Sections

### Graph Explorer

Allows navigation through the enterprise hierarchy.

``` text
Industry
  ↓
Value Chain
  ↓
Process
  ↓
Activity
```

### AI Assessment

Displays structured intelligence:

``` text
Automation
Augmentation
AI Mode
Classification
Confidence
AI Opportunity
Technology
```

### Runtime AI Reasoning

Displays Llama-generated reasoning:

``` text
Executive Summary
Automation Reasoning
Augmentation Reasoning
Human Role
Skill Change
Future Outlook
Model Confidence
```

### Impact Cascade

Displays workforce effects:

``` text
Roles affected
Skills affected
Related activities
Future roles
Future skills
```

### Surprise Record Test

Provides runtime ingestion:

``` text
New Activity
     ↓
Backend ingestion
     ↓
AI pipeline
     ↓
Result
```

------------------------------------------------------------------------

# 5. Backend Architecture

The backend is implemented using FastAPI.

Current conceptual structure:

``` text
backend/
└── app/
    │
    ├── main.py
    │
    ├── api/
    │   └── routes/
    │       ├── health.py
    │       ├── industries.py
    │       ├── processes.py
    │       ├── activities.py
    │       ├── roles.py
    │       ├── skills.py
    │       ├── graph.py
    │       ├── ai_analysis.py
    │       └── ingestion.py
    │
    ├── ai/
    │   ├── classifier.py
    │   ├── analyzer.py
    │   └── reasoning.py
    │
    ├── db/
    │   ├── database.py
    │   ├── session.py
    │   └── repositories.py
    │
    ├── models/
    │   ├── activity.py
    │   ├── process.py
    │   ├── role.py
    │   ├── skill.py
    │   ├── ai_opportunity.py
    │   └── impact.py
    │
    ├── schemas/
    │   └── ...
    │
    └── services/
        ├── graph_service.py
        ├── ingestion_service.py
        └── impact_service.py
```

------------------------------------------------------------------------

# 6. API Layer

FastAPI acts as the boundary between the frontend and intelligence
system.

The API layer is intentionally thin.

``` text
HTTP Request
     ↓
FastAPI Route
     ↓
Service / Repository
     ↓
Database / AI Layer
     ↓
JSON Response
```

Routes are responsible for:

-   Request validation
-   Dependency injection
-   Calling services
-   HTTP error handling
-   Formatting responses

Business logic belongs in services and AI modules rather than being
duplicated across routes.

------------------------------------------------------------------------

# 7. Graph Data Layer

The enterprise graph is represented in PostgreSQL using relational
tables and foreign-key relationships.

The conceptual graph is:

``` text
Industry
   │
   ▼
Value Chain
   │
   ▼
Process
   │
   ▼
Activity
   ├──────────► Role
   │
   ├──────────► Skill
   │
   ▼
AI Opportunity
   │
   ▼
AI Impact Cascade
```

PostgreSQL provides durable enterprise context that can be queried
deterministically.

------------------------------------------------------------------------

# 8. SQLAlchemy Layer

SQLAlchemy models represent database entities as Python objects.

For example:

``` text
Activity
    activity_id
    process_id
    activity_code
    name
    description
    activity_type
    automation_level
    sequence_order
```

Relationships allow application code to navigate enterprise entities
while preserving database constraints.

The ORM layer sits between:

``` text
FastAPI / Services
        ↓
SQLAlchemy
        ↓
PostgreSQL
```

------------------------------------------------------------------------

# 9. Repository Layer

`GraphRepository` is responsible for retrieving graph facts.

Typical responsibilities include retrieving:

-   Activities
-   Processes
-   Roles
-   Skills
-   Activity-role relationships
-   Activity-skill relationships
-   Process context

The repository layer prevents route handlers from containing raw
database traversal logic.

Conceptually:

``` text
Route
  ↓
Service
  ↓
GraphRepository
  ↓
SQLAlchemy
  ↓
PostgreSQL
```

------------------------------------------------------------------------

# 10. Graph Service

`GraphService` provides higher-level graph operations.

It can combine repository results into application-oriented responses.

For example:

``` text
get_activity()
get_activity_roles()
get_activity_skills()
```

This creates a clean separation between:

-   Database retrieval
-   Graph interpretation
-   API presentation

------------------------------------------------------------------------

# 11. AI Intelligence Layer

The AI layer contains three important components:

``` text
┌────────────────────────────┐
│ ActivityClassifier         │
│                            │
│ What type of work is this? │
└──────────────┬─────────────┘
               ▼
┌────────────────────────────┐
│ AIAnalyzer                 │
│                            │
│ How can AI affect it?      │
└──────────────┬─────────────┘
               ▼
┌────────────────────────────┐
│ LlamaReasoner              │
│                            │
│ Why does that assessment   │
│ make sense?                │
└────────────────────────────┘
```

------------------------------------------------------------------------

# 12. Activity Classifier

`ActivityClassifier` performs deterministic activity classification.

Example categories include:

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

The classifier returns structured information such as:

``` json
{
  "category": "ANALYSIS",
  "confidence": 0.9,
  "matched_keywords": [
    "analysis",
    "monitor",
    "track"
  ]
}
```

This classification is generated by application logic and does not
depend on the LLM.

------------------------------------------------------------------------

# 13. AI Analyzer

`AIAnalyzer` performs the structured AI assessment.

The result includes:

``` text
Automation Score
Augmentation Score
AI Mode
Confidence
Opportunity
Technology
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

The assessment provides a deterministic foundation for the generative
reasoning layer.

------------------------------------------------------------------------

# 14. AI Opportunity Model

AI opportunities are persisted against activities.

Conceptually:

``` text
Activity
   │
   └──────► AI Opportunity
                │
                ├── AI Type
                ├── Technology
                ├── Automation Score
                ├── Augmentation Score
                ├── Confidence
                └── Status
```

This allows the application to retrieve stored intelligence without
recalculating the entire assessment on every request.

------------------------------------------------------------------------

# 15. Llama Reasoning Architecture

The local LLM is intentionally downstream from the deterministic
intelligence layer.

``` text
Activity
   ↓
Classification
   ↓
AI Assessment
   ↓
Graph Context
   ↓
Llama 3.2
   ↓
Structured Reasoning
```

The LLM receives context such as:

-   Activity details
-   Classification
-   AI assessment
-   AI opportunity
-   Roles
-   Skills
-   Cascade summary

It returns reasoning around the workforce implications.

------------------------------------------------------------------------

# 16. Why Local Llama?

NovaCart AI currently uses:

``` text
Ollama
   ↓
Llama 3.2
```

The local architecture provides:

-   Local development
-   No requirement for a hosted LLM API
-   Reproducible experimentation
-   Clear separation between application facts and model reasoning
-   A practical privacy-oriented development model

The platform can still operate its deterministic assessment when Llama
is unavailable.

------------------------------------------------------------------------

# 17. Impact Intelligence Architecture

The impact layer answers a different question from the AI analyzer.

### AI Analyzer asks:

> "How suitable is this activity for AI?"

### Impact Service asks:

> "What workforce consequences can follow from that AI opportunity?"

The relationship is:

``` text
AI Assessment
      ↓
AI Opportunity
      ↓
Impact Service
      ↓
Workforce Cascade
```

------------------------------------------------------------------------

# 18. AI Impact Cascade

The cascade is the workforce intelligence layer.

Conceptually:

``` text
                 Activity
                    │
                    ▼
              AI Opportunity
                    │
                    ▼
               Direct Impact
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
        Roles               Skills
          │                   │
          └─────────┬─────────┘
                    ▼
            Related Activities
                    │
                    ▼
              Future Roles
                    │
                    ▼
              Future Skills
```

The current cascade model stores:

``` text
source_activity_id
source_ai_opportunity_id
affected_activity_id
affected_role_id
affected_skill_id
impact_level
impact_score
reasoning
created_at
```

------------------------------------------------------------------------

# 19. Impact Levels

The conceptual cascade is organized into five levels.

### Level 1 --- Direct Impact

The selected activity and its immediate AI opportunity.

### Level 2 --- Role / Activity Impact

Roles directly associated with the transformed work.

### Level 3 --- Skill Impact

Capabilities connected to the affected work.

### Level 4 --- Future Role Impact

Potential future workforce-role changes.

### Level 5 --- Future Skill Impact

Capabilities that may become more important as work changes.

The exact records returned depend on the graph relationships and
impact-generation logic for the selected activity.

------------------------------------------------------------------------

# 20. Runtime Ingestion Architecture

Runtime ingestion is one of the platform's key capabilities.

A new activity can enter the system through the ingestion API.

``` text
User
 │
 │ New Activity
 ▼
Frontend
 │
 ▼
POST /api/ingestion/activities
 │
 ▼
IngestionService
 │
 ├──────────────► Create Activity
 │
 ├──────────────► Classify
 │
 ├──────────────► AI Assessment
 │
 ├──────────────► Create Opportunity
 │
 ├──────────────► Generate Impact
 │
 └──────────────► Runtime Reasoning
 │
 ▼
Complete Intelligence Response
```

This means the frontend does not require a hardcoded record for every
activity it displays.

------------------------------------------------------------------------

# 21. Runtime Activity Lifecycle

The runtime lifecycle is:

``` text
1. INGEST
      ↓
2. CLASSIFY
      ↓
3. ASSESS
      ↓
4. OPPORTUNITY
      ↓
5. GRAPH CONTEXT
      ↓
6. LLAMA REASONING
      ↓
7. IMPACT CASCADE
      ↓
8. RESPONSE
      ↓
9. FRONTEND VISUALIZATION
```

A successful runtime response can contain:

``` text
activity
classification
analysis
llm_reasoning
graph_context
```

------------------------------------------------------------------------

# 22. Example Runtime Flow

Suppose a user enters:

``` text
Name:
Analyze supplier risk

Description:
Evaluate supplier performance, delivery reliability,
and commercial risk before contract renewal.

Type:
ANALYSIS
```

The system processes:

``` text
Analyze supplier risk
        │
        ▼
ANALYSIS
        │
        ▼
Automation / Augmentation Assessment
        │
        ▼
AI Opportunity
        │
        ▼
Llama 3.2 Reasoning
        │
        ▼
Roles + Skills
        │
        ▼
Impact Cascade
```

The frontend then renders the resulting intelligence.

------------------------------------------------------------------------

# 23. AI Analysis Endpoint Flow

For:

``` text
GET /api/ai-analysis/activities/{activity_id}
```

the flow is approximately:

``` text
Request
  ↓
FastAPI Route
  ↓
ImpactService
  ↓
PostgreSQL
  ↓
Stored AI Opportunity
  ↓
JSON Response
```

This endpoint is intended for stored intelligence.

------------------------------------------------------------------------

# 24. Cascade Endpoint Flow

For:

``` text
GET /api/ai-analysis/activities/{activity_id}/cascade
```

the flow is:

``` text
Request
  ↓
FastAPI Route
  ↓
ImpactService
  ↓
Cascade Records
  ↓
Summary + Entity Groups
  ↓
JSON Response
```

The frontend uses this information to render the workforce impact
section.

------------------------------------------------------------------------

# 25. Runtime Reasoning Endpoint Flow

For:

``` text
POST /api/ai-analysis/activities/{activity_id}/reason
```

the flow is:

``` text
Request
  ↓
Retrieve Activity
  ↓
Build Activity Data
  ↓
Classify Activity
  ↓
Retrieve AI Opportunities
  ↓
Retrieve Roles
  ↓
Retrieve Skills
  ↓
Run AIAnalyzer
  ↓
Retrieve Cascade Summary
  ↓
Run LlamaReasoner
  ↓
Return Complete Reasoning
```

This endpoint combines verified graph context with local generative
reasoning.

------------------------------------------------------------------------

# 26. Data Ownership

A key architecture rule is:

``` text
┌───────────────────────────┐
│ PostgreSQL                │
│                           │
│ Enterprise facts         │
│ Relationships            │
│ Stored opportunities     │
│ Impact records           │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│ Application AI            │
│                           │
│ Deterministic assessment  │
│ Classification            │
│ Scoring                   │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│ Llama 3.2                 │
│                           │
│ Explanation / reasoning   │
└───────────────────────────┘
```

The LLM should not invent graph relationships that are presented as
verified enterprise facts.

------------------------------------------------------------------------

# 27. Error and Degradation Strategy

NovaCart AI has multiple independent intelligence layers.

This allows partial degradation.

For example:

``` text
PostgreSQL available
       +
Deterministic AI available
       +
Ollama unavailable
       =
Structured AI still available
```

The frontend can therefore distinguish:

``` text
AI assessment available
LLM reasoning unavailable
```

instead of treating the entire activity analysis as a failure.

Similarly, an invalid activity ID returns a clear `404` rather than
producing an undefined application state.

------------------------------------------------------------------------

# 28. Frontend-to-Backend Contract

The frontend should treat API responses as structured data.

For example, a successful reasoning response has the conceptual shape:

``` json
{
  "activity": {},
  "classification": {},
  "analysis": {},
  "llm_reasoning": {},
  "graph_context": {}
}
```

The cascade response has the conceptual shape:

``` json
{
  "activity": {},
  "cascade": {
    "level_1_direct": [],
    "level_2_role_activity": [],
    "level_3_skill": [],
    "level_4_future_role": [],
    "level_5_future_skill": []
  },
  "summary": {
    "total_cascade_records": 0,
    "level_1_count": 0,
    "level_2_count": 0,
    "level_3_count": 0,
    "level_4_count": 0,
    "level_5_count": 0
  }
}
```

The frontend normalizes these records for presentation because runtime
and pre-computed cascade records can use different levels.

------------------------------------------------------------------------

# 29. Security Boundary

The current architecture is designed primarily as a development and
demonstration platform.

The current architecture does not claim to provide production-grade:

-   Authentication
-   Authorization
-   Multi-tenancy
-   Secrets management
-   Rate limiting
-   Audit logging

These can be introduced as future infrastructure layers.

For a production deployment, the recommended boundary would be:

``` text
Client
  ↓
Authentication / API Gateway
  ↓
FastAPI
  ↓
Services
  ↓
Database / AI Infrastructure
```

------------------------------------------------------------------------

# 30. Deployment Concept

The current local architecture can be represented as:

``` text
┌──────────────────────┐
│ Browser              │
│ React / Vite         │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ FastAPI              │
│ localhost:8000       │
└──────┬─────────┬─────┘
       │         │
       ▼         ▼
┌────────────┐ ┌────────────┐
│ PostgreSQL │ │  Ollama    │
│            │ │ Llama 3.2  │
└────────────┘ └────────────┘
```

The architecture can later be containerized and deployed to a cloud
environment without changing the conceptual application layers.

------------------------------------------------------------------------

# 31. Request Sequence --- Existing Activity

``` text
Browser
  │
  │ select activity
  ▼
React
  │
  ├── GET activity / graph data
  │
  ├── GET AI opportunity
  │
  ├── GET cascade
  │
  └── POST reason
           │
           ▼
       FastAPI
           │
     ┌─────┼───────────┐
     ▼     ▼           ▼
  Graph  AIAnalyzer  ImpactService
     │     │           │
     └─────┼───────────┘
           ▼
      LlamaReasoner
           │
           ▼
        Ollama
           │
           ▼
      JSON response
           │
           ▼
         React
```

------------------------------------------------------------------------

# 32. Request Sequence --- New Activity

``` text
Browser
  │
  │ submit new activity
  ▼
React
  │
  ▼
POST /api/ingestion/activities
  │
  ▼
IngestionService
  │
  ├── Create activity
  │
  ├── Classify
  │
  ├── Assess
  │
  ├── Create AI opportunity
  │
  ├── Generate impact
  │
  └── Runtime reasoning
  │
  ▼
PostgreSQL + Ollama
  │
  ▼
Complete response
  │
  ▼
React dashboard
```

------------------------------------------------------------------------

# 33. Why This Architecture?

The architecture is designed around four goals.

## 1. Explainability

Every AI conclusion can be connected to structured enterprise context.

## 2. Separation of Concerns

Database retrieval, deterministic AI, generative reasoning, and
presentation are separate layers.

## 3. Runtime Extensibility

New activities can enter the intelligence pipeline without changing the
frontend's underlying data model.

## 4. Workforce-Centric Analysis

The system goes beyond an automation percentage and attempts to show how
AI affects the broader workforce capability graph.

------------------------------------------------------------------------

# 34. Architectural Trade-offs

### PostgreSQL Graph Instead of a Dedicated Graph Database

The current implementation uses PostgreSQL relational modeling for the
enterprise graph.

**Benefit:**

-   Familiar SQL ecosystem
-   Strong constraints
-   Mature ORM support
-   Simple local development

**Trade-off:**

Complex graph traversal can eventually require more specialized
graph-oriented infrastructure.

------------------------------------------------------------------------

### Local Llama Instead of Hosted LLM

**Benefit:**

-   Local execution
-   Lower external dependency
-   Useful for experimentation
-   Better control over development data

**Trade-off:**

-   Requires local model resources
-   Model availability affects reasoning latency
-   Quality depends on local model capabilities

------------------------------------------------------------------------

### Deterministic AI + LLM

Instead of asking the LLM to perform everything:

``` text
Database → deterministic logic → LLM
```

This adds architectural complexity but improves control and
explainability.

------------------------------------------------------------------------

# 35. Current Architecture Status

  Layer                   Status
  ----------------------- --------
  React frontend          ✅
  Graph explorer          ✅
  FastAPI API             ✅
  PostgreSQL graph        ✅
  SQLAlchemy models       ✅
  Graph repository        ✅
  Graph service           ✅
  Activity classifier     ✅
  AI analyzer             ✅
  AI opportunity layer    ✅
  Ollama integration      ✅
  Llama 3.2 reasoning     ✅
  Impact service          ✅
  AI impact cascade       ✅
  Runtime ingestion       ✅
  Cascade visualization   ✅

------------------------------------------------------------------------

# 36. Future Architecture

Potential future architecture:

``` text
                         ┌─────────────────────┐
                         │ Authentication      │
                         │ / API Gateway       │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │ FastAPI Services    │
                         └──────┬──────┬───────┘
                                │      │
                  ┌─────────────┘      └─────────────┐
                  ▼                                   ▼
          ┌───────────────┐                   ┌───────────────┐
          │ PostgreSQL    │                   │ AI Gateway    │
          │ Enterprise    │                   │               │
          │ Graph         │                   │ Model Router  │
          └───────────────┘                   └───────┬───────┘
                                                      │
                                  ┌───────────────────┼─────────────────┐
                                  ▼                   ▼                 ▼
                              Llama 3.2          Other LLMs        Embeddings
                                  │
                                  ▼
                         ┌─────────────────────┐
                         │ Workforce           │
                         │ Intelligence Engine  │
                         └─────────────────────┘
```

Potential additions include:

-   Authentication
-   Role-based access control
-   Multi-tenancy
-   Model routing
-   Vector search
-   Semantic activity matching
-   AI opportunity prioritization
-   Workforce skill-gap analysis
-   ROI analysis
-   Audit trails
-   Production observability
-   Background processing
-   Cloud deployment

These are future extensions, not assumptions about the current
implementation.

------------------------------------------------------------------------

# 37. Architecture Summary

NovaCart AI can be summarized as:

``` text
                         NOVACART AI
                              │
              ┌───────────────┴───────────────┐
              │                               │
       ENTERPRISE GRAPH                 AI INTELLIGENCE
              │                               │
         PostgreSQL                    Deterministic AI
              │                               │
              │                               ▼
              │                         AI Opportunity
              │                               │
              └──────────────┬────────────────┘
                             ▼
                      Llama 3.2 Reasoning
                             │
                             ▼
                       Impact Service
                             │
             ┌───────────────┼────────────────┐
             ▼               ▼                ▼
           Roles           Skills       Related Work
             │               │                │
             └───────────────┼────────────────┘
                             ▼
                     Future Workforce
                             │
                             ▼
                       React Dashboard
```

The core architectural idea is simple:

> **Use structured enterprise data to establish what is true,
> deterministic intelligence to quantify AI opportunity, and local LLM
> reasoning to explain what the transformation means for people and
> work.**
