# NovaCart AI

> **Enterprise AI Workforce Intelligence Platform**

NovaCart AI is an enterprise intelligence platform that analyzes
business activities, evaluates where AI can automate or augment work,
uses a local Llama 3.2 model for contextual reasoning, and traces the
resulting workforce impact across roles, skills, related activities, and
future capabilities.

The platform combines a **PostgreSQL-backed enterprise graph**,
**FastAPI backend**, **deterministic AI analysis**, **runtime LLM
reasoning through Ollama**, and a **React frontend** into one end-to-end
intelligence workflow.

------------------------------------------------------------------------

## Overview

Organizations usually know that AI will change work, but answering
**what changes, where, and who is affected** requires connecting several
layers of enterprise context.

NovaCart AI models that relationship as:

``` text
Enterprise Activity
        │
        ▼
   Classification
        │
        ▼
   AI Assessment
        │
        ▼
   AI Opportunity
        │
        ▼
  Local Llama Reasoning
        │
        ▼
   Impact Cascade
        │
        ├── Roles
        ├── Skills
        ├── Related Activities
        ├── Future Roles
        └── Future Skills
```

The result is not just an automation score. It is a workforce-oriented
view of how an AI opportunity can propagate through an enterprise
operating model.

------------------------------------------------------------------------

## Key Capabilities

### Enterprise Graph Exploration

Navigate enterprise structure through:

``` text
Industry
   ↓
Value Chain
   ↓
Process
   ↓
Activity
```

The selected activity becomes the source context for downstream AI
analysis.

### AI Opportunity Assessment

For an activity, NovaCart AI evaluates:

-   Automation potential
-   Augmentation potential
-   Recommended AI mode
-   Classification category
-   Confidence
-   AI opportunity
-   Recommended technology

Example:

``` text
Automation       81%
Augmentation     95%
AI Mode          HIGH_AUTOMATION
Classification   ANALYSIS
Technology       Machine Learning + Analytics
```

### Local LLM Reasoning

NovaCart AI can send the verified activity and graph context to a
locally hosted **Llama 3.2** model through **Ollama**.

The reasoning layer produces structured explanations for:

-   Executive summary
-   Automation reasoning
-   Augmentation reasoning
-   Human role
-   Skill change
-   Future outlook
-   Model confidence

The deterministic AI assessment remains available if the local LLM is
unavailable.

### AI Impact Cascade

The impact engine traces workforce consequences across multiple levels:

``` text
Level 1 → Direct Impact
Level 2 → Role / Activity Impact
Level 3 → Skill Impact
Level 4 → Future Role Impact
Level 5 → Future Skill Impact
```

The frontend visualizes the cascade through:

-   Total impact
-   Direct impacts
-   Roles affected
-   Skills affected
-   Related activities
-   Future roles
-   Future skills

### Runtime Activity Ingestion

NovaCart AI supports introducing an activity that does not already exist
in the graph.

Example:

``` text
"Analyze supplier risk"
```

The runtime pipeline can then:

``` text
INGEST
  ↓
CLASSIFY
  ↓
AI ASSESS
  ↓
LLAMA
  ↓
IMPACT CASCADE
  ↓
DISPLAY RESULT
```

This provides a practical demonstration of runtime enterprise
intelligence instead of only displaying preloaded records.

------------------------------------------------------------------------

## Architecture

``` text
                         ┌──────────────────────┐
                         │     React Frontend   │
                         │  Enterprise Dashboard│
                         └──────────┬───────────┘
                                    │ HTTP
                                    ▼
                         ┌──────────────────────┐
                         │      FastAPI API     │
                         │                      │
                         │ Activities           │
                         │ Processes            │
                         │ Graph                │
                         │ AI Analysis           │
                         │ Ingestion             │
                         └───────┬───────┬──────┘
                                 │       │
                    ┌────────────┘       └──────────────┐
                    ▼                                   ▼
          ┌──────────────────┐                 ┌──────────────────┐
          │   AI Intelligence│                 │  Impact Service  │
          │                  │                 │                  │
          │ Classifier       │                 │ Role impacts     │
          │ AI Analyzer      │                 │ Skill impacts    │
          │ Llama Reasoner   │                 │ Future impacts   │
          └────────┬─────────┘                 └────────┬─────────┘
                   │                                    │
                   │                                    │
                   ▼                                    ▼
          ┌──────────────────┐                 ┌──────────────────┐
          │ Ollama / Llama   │                 │   PostgreSQL     │
          │ 3.2 Local LLM    │◄───────────────►│ Enterprise Graph │
          └──────────────────┘                 └──────────────────┘
```

### Design Principle

**PostgreSQL is the source of truth for enterprise graph facts.**

The LLM is used for contextual reasoning and natural-language
explanation. It does not replace the database graph or deterministic
assessment layer.

This separation helps keep the system:

-   Explainable
-   Testable
-   Reproducible
-   Resilient when the local model is unavailable

------------------------------------------------------------------------

## Technology Stack

  Layer               Technology
  ------------------- --------------------------------------
  Frontend            React
  Frontend tooling    Vite
  Backend             FastAPI
  Language            Python
  Database            PostgreSQL
  ORM                 SQLAlchemy
  Local LLM runtime   Ollama
  LLM                 Llama 3.2
  API communication   REST
  Enterprise graph    Relational graph model in PostgreSQL

------------------------------------------------------------------------

## Project Structure

``` text
Nova_Cart_AI/
│
├── backend/
│   └── app/
│       ├── ai/
│       │   ├── analyzer.py
│       │   ├── classifier.py
│       │   └── reasoning.py
│       │
│       ├── api/
│       │   └── routes/
│       │       ├── activities.py
│       │       ├── ai_analysis.py
│       │       ├── graph.py
│       │       ├── health.py
│       │       ├── industries.py
│       │       ├── ingestion.py
│       │       ├── processes.py
│       │       ├── roles.py
│       │       └── skills.py
│       │
│       ├── db/
│       │   ├── database.py
│       │   ├── repositories.py
│       │   └── session.py
│       │
│       ├── models/
│       │   ├── activity.py
│       │   ├── ai_opportunity.py
│       │   ├── impact.py
│       │   ├── process.py
│       │   ├── role.py
│       │   └── skill.py
│       │
│       ├── schemas/
│       │   └── ...
│       │
│       └── services/
│           ├── graph_service.py
│           ├── impact_service.py
│           └── ingestion_service.py
│
├── frontend/
│   └── src/
│       ├── App.jsx
│       ├── App.css
│       └── index.css
│
├── database/
│   └── ...
│
└── README.md
```

------------------------------------------------------------------------

## Data Model

The core enterprise intelligence model connects:

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
   │
   ├──────────────► Roles
   │
   ├──────────────► Skills
   │
   ▼
AI Opportunity
   │
   ▼
AI Impact Cascade
```

### AI Opportunity

AI opportunities are associated with activities and contain information
such as:

-   Opportunity name
-   Description
-   AI type
-   Technology
-   Automation score
-   Augmentation score
-   Confidence score
-   Status

### AI Impact Cascade

Impact records can connect:

-   Source activity
-   Source AI opportunity
-   Affected activity
-   Affected role
-   Affected skill
-   Impact level
-   Impact score
-   Reasoning

This allows the platform to represent both immediate and downstream
workforce effects.

------------------------------------------------------------------------

## AI Intelligence Pipeline

### 1. Activity Classification

The deterministic classifier examines the activity name, description,
and activity context.

It produces:

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

### 2. AI Assessment

The analyzer evaluates the potential for:

-   Automation
-   Augmentation
-   AI transformation mode
-   Confidence

### 3. Opportunity Resolution

Stored AI opportunity information is retrieved from PostgreSQL.

### 4. Graph Context

The system retrieves verified:

-   Roles
-   Skills
-   Process context
-   Existing relationships

### 5. Llama Reasoning

Ollama provides natural-language reasoning based on the structured
context.

### 6. Impact Cascade

The impact service resolves workforce consequences and returns the
cascade to the frontend.

------------------------------------------------------------------------

## Runtime Intelligence

The most distinctive demonstration path is the runtime ingestion
workflow.

A user can enter a completely new activity:

``` text
Activity:
Analyze supplier risk

Description:
Evaluate supplier performance, delivery reliability,
and commercial risk before contract renewal.
```

NovaCart AI processes it without requiring the activity to be manually
inserted into the frontend.

The result can contain:

``` text
Activity
   ↓
Classification
   ↓
AI Opportunity
   ↓
Automation / Augmentation Assessment
   ↓
Llama 3.2 Reasoning
   ↓
Roles
   ↓
Skills
   ↓
Future Workforce Impact
```

------------------------------------------------------------------------

## API

The backend exposes REST endpoints for the major intelligence layers.

### Health

``` text
GET /api/health
```

### Enterprise Navigation

``` text
GET /api/industries
GET /api/processes/...
GET /api/activities/...
```

### Activity Intelligence

``` text
GET /api/ai-analysis/activities/{activity_id}
```

Returns stored AI opportunity information.

### Impact Cascade

``` text
GET /api/ai-analysis/activities/{activity_id}/cascade
```

Returns the pre-computed workforce impact cascade.

### Runtime LLM Reasoning

``` text
POST /api/ai-analysis/activities/{activity_id}/reason
```

Runs contextual reasoning through the local Llama model.

### Runtime Activity Ingestion

``` text
POST /api/ingestion/activities
```

Creates and processes a new activity through the runtime intelligence
pipeline.

> Endpoint names should be treated as the current application contract;
> detailed request and response examples can be maintained in
> `docs/API.md`.

------------------------------------------------------------------------

## Local Development

### Prerequisites

Install:

-   Python 3.12
-   Node.js / npm
-   PostgreSQL
-   Ollama

Make sure PostgreSQL is running and the required NovaCart AI
database/schema has been initialized.

Install the required local Llama model through Ollama before testing
runtime reasoning.

------------------------------------------------------------------------

## Backend Setup

From the project root:

``` powershell
cd backend
```

Activate the project virtual environment:

``` powershell
..\.venv\Scripts\Activate.ps1
```

If the environment is already active, simply continue.

Start FastAPI:

``` powershell
uvicorn app.main:app --reload
```

The API is available at:

``` text
http://127.0.0.1:8000
```

Interactive API documentation:

``` text
http://127.0.0.1:8000/docs
```

------------------------------------------------------------------------

## Frontend Setup

Open another terminal:

``` powershell
cd frontend
npm install
npm run dev
```

Open the Vite development URL shown in the terminal.

The frontend communicates with the FastAPI backend.

------------------------------------------------------------------------

## Ollama / Llama

NovaCart AI uses a local Ollama runtime for Llama reasoning.

The expected model in the current application is:

``` text
llama3.2:latest
```

Verify that Ollama is available before testing runtime reasoning.

If the LLM is unavailable, the application is designed to preserve the
deterministic AI assessment and present a clear
local-reasoning-unavailable state.

------------------------------------------------------------------------

## Recommended Demo

For a recruiter or technical interview, use this flow:

### Demo 1 --- Existing Activity

1.  Open the NovaCart AI dashboard.
2.  Select an industry.
3.  Select a value chain.
4.  Select a process.
5.  Select an activity.
6.  Show the AI assessment.
7.  Show the Llama 3.2 reasoning.
8.  Scroll to **AI Impact Cascade**.
9.  Show affected roles and skills.
10. Show future workforce impacts.

### Demo 2 --- Runtime Intelligence

Use the **Surprise Record Test**.

Example:

``` text
Name:
Analyze supplier risk

Description:
Evaluate supplier performance, delivery reliability,
and commercial risk before contract renewal.

Type:
ANALYSIS
```

Run:

``` text
INGEST → CLASSIFY → ASSESS → LLAMA → CASCADE
```

Then demonstrate that the newly created activity receives its own
intelligence response.

------------------------------------------------------------------------

## Example Intelligence Result

A successful activity analysis can contain:

``` text
Classification
    ANALYSIS
    Confidence: 90%

AI Assessment
    Automation: 81%
    Augmentation: 95%
    Mode: HIGH_AUTOMATION

AI Opportunity
    Intelligent Automation
    Machine Learning + Analytics

Runtime Reasoning
    Llama 3.2
    Ollama

Workforce Impact
    Roles affected
    Skills affected
    Related activities
    Future roles
    Future skills
```

The exact values depend on the selected activity and current graph data.

------------------------------------------------------------------------

## Reliability and Explainability

NovaCart AI deliberately separates **facts** from **reasoning**.

### Verified graph facts

Stored in PostgreSQL:

-   Activities
-   Processes
-   Roles
-   Skills
-   Relationships
-   AI opportunities
-   Impact records

### Deterministic intelligence

Calculated by application logic:

-   Activity classification
-   Automation assessment
-   Augmentation assessment
-   Impact scoring

### Generative reasoning

Produced by the local Llama model:

-   Explanations
-   Human-role interpretation
-   Skill-change reasoning
-   Future outlook

This architecture prevents the LLM from becoming the sole source of
enterprise truth.

------------------------------------------------------------------------

## Current Status

  Capability                       Status
  -------------------------------- --------
  PostgreSQL enterprise graph      ✅
  Activity model                   ✅
  Process / activity navigation    ✅
  Role relationships               ✅
  Skill relationships              ✅
  Activity classification          ✅
  AI assessment                    ✅
  AI opportunities                 ✅
  Runtime activity ingestion       ✅
  Ollama integration               ✅
  Llama 3.2 reasoning              ✅
  AI impact cascade                ✅
  Role impact visualization        ✅
  Skill impact visualization       ✅
  Future workforce visualization   ✅
  React dashboard                  ✅
  Documentation                    🔄

------------------------------------------------------------------------

## Engineering Principles

NovaCart AI follows several practical engineering principles:

### Database as Source of Truth

Enterprise relationships come from PostgreSQL rather than being invented
by the LLM.

### Deterministic Before Generative

Structured analysis is performed before LLM reasoning.

### Local AI

Llama 3.2 can run locally through Ollama, making the reasoning layer
suitable for experimentation without requiring a hosted LLM API.

### Runtime First-Class Support

The system is not limited to static demo data. New activities can enter
the intelligence pipeline at runtime.

### Explainable Workforce Impact

The platform attempts to answer not only:

> "Can AI automate this?"

but also:

> "What happens to the people and capabilities connected to this work?"

------------------------------------------------------------------------

## Future Improvements

Potential future extensions include:

-   Authentication and enterprise user management
-   Multi-tenant architecture
-   Role-to-skill gap analysis
-   AI opportunity prioritization
-   Cost / ROI estimation
-   Workforce transition recommendations
-   Historical impact tracking
-   More advanced graph traversal
-   Vector-based semantic activity matching
-   Model evaluation and benchmarking
-   Production observability
-   CI/CD and automated testing
-   Cloud deployment

These are future directions and are not required for the current working
demo.

------------------------------------------------------------------------

## Documentation Roadmap

Additional project documentation can be maintained under `docs/`:

``` text
docs/
├── ARCHITECTURE.md
├── API.md
├── AI_PIPELINE.md
├── DATABASE.md
├── IMPACT_CASCADE.md
├── DEMO_GUIDE.md
└── PROJECT_STATUS.md
```

Each document should describe the implementation actually present in the
repository.

------------------------------------------------------------------------

## License

Add the project's chosen license here before publishing the repository
publicly.

------------------------------------------------------------------------

## Author

**Dhruv Kajla**

NovaCart AI --- Enterprise AI Workforce Intelligence Platform
