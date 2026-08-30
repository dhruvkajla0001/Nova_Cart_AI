# NovaCart AI --- API Documentation

> REST API reference for the current NovaCart AI backend.

## Base URL

Local development:

``` text
http://127.0.0.1:8000
```

Interactive documentation:

``` text
http://127.0.0.1:8000/docs
```

------------------------------------------------------------------------

# 1. API Architecture

``` text
React Frontend
      │
      │ HTTP / JSON
      ▼
FastAPI
      │
      ├── Graph Routes
      ├── Activity Routes
      ├── AI Analysis Routes
      └── Ingestion Routes
      │
      ▼
Services / Repositories
      │
      ├── PostgreSQL
      └── Ollama / Llama 3.2
```

------------------------------------------------------------------------

# 2. Response Convention

Successful responses use JSON.

Errors use FastAPI's standard error format:

``` json
{
  "detail": "Activity 85 not found"
}
```

HTTP `404` is returned when an activity does not exist.

------------------------------------------------------------------------

# 3. Health API

## `GET /api/health`

Checks whether the backend is available.

### Example

``` text
GET http://127.0.0.1:8000/api/health
```

Use this endpoint before starting a frontend demo to confirm that
FastAPI is running.

------------------------------------------------------------------------

# 4. Enterprise Graph APIs

The application exposes routes for navigating the enterprise graph.

Current route modules include:

``` text
/api/industries
/api/processes
/api/activities
/api/roles
/api/skills
/api/graph
```

These routes provide the enterprise context used by the frontend and
downstream AI analysis.

The exact route parameters should be verified against the generated
FastAPI Swagger documentation at:

``` text
http://127.0.0.1:8000/docs
```

------------------------------------------------------------------------

# 5. AI Analysis API

The main AI intelligence endpoints are under:

``` text
/api/ai-analysis
```

------------------------------------------------------------------------

## 5.1 Get Stored AI Analysis

### `GET /api/ai-analysis/activities/{activity_id}`

Retrieves stored AI opportunities for an activity.

### Path Parameter

``` text
activity_id
```

Example:

``` text
GET /api/ai-analysis/activities/1
```

### Successful Response

``` json
{
  "activity": {
    "activity_id": 1,
    "activity_code": "ACT_CA_010",
    "name": "Track conversion funnel",
    "description": "Monitor customer movement from prospect to completed purchase.",
    "activity_type": "ANALYSIS",
    "sequence_order": 3
  },
  "ai_opportunities": [
    {
      "ai_opportunity_id": 1,
      "name": "AI Automation for Track conversion funnel",
      "description": "Apply AI to analyze, automate, optimize, or augment this activity based on its process context and available data.",
      "ai_type": "INTELLIGENT_AUTOMATION",
      "technology": "Machine Learning + Analytics",
      "automation_score": 81,
      "augmentation_score": 95,
      "confidence_score": 93,
      "status": "identified"
    }
  ]
}
```

### Not Found

``` json
{
  "detail": "Activity 85 not found"
}
```

------------------------------------------------------------------------

# 6. AI Impact Cascade API

## `GET /api/ai-analysis/activities/{activity_id}/cascade`

Retrieves the pre-computed workforce impact cascade.

### Example

``` text
GET /api/ai-analysis/activities/1/cascade
```

The cascade conceptually follows:

``` text
Activity
   ↓
AI Opportunity
   ↓
Direct Impact
   ↓
Roles
   ↓
Skills
   ↓
Future Roles
   ↓
Future Skills
```

### Response Shape

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

The frontend normalizes cascade records so role and skill impacts remain
visible even when runtime records use a different cascade level.

------------------------------------------------------------------------

# 7. Runtime LLM Reasoning

## `POST /api/ai-analysis/activities/{activity_id}/reason`

Runs runtime AI reasoning using the locally hosted Llama 3.2 model
through Ollama.

### Example

``` text
POST /api/ai-analysis/activities/1/reason
```

No request body is required by the current route.

------------------------------------------------------------------------

## 7.1 Processing Flow

``` text
Activity ID
    ↓
Retrieve Activity
    ↓
ActivityClassifier
    ↓
Stored AI Opportunities
    ↓
GraphRepository
    ↓
Roles + Skills
    ↓
AIAnalyzer
    ↓
Impact Cascade Summary
    ↓
LlamaReasoner
    ↓
Ollama / Llama 3.2
    ↓
Complete JSON Response
```

------------------------------------------------------------------------

# 8. Reasoning Response

A successful reasoning response contains:

``` json
{
  "activity": {},
  "classification": {},
  "analysis": {},
  "llm_reasoning": {},
  "graph_context": {}
}
```

------------------------------------------------------------------------

## 8.1 Activity

Example:

``` json
{
  "activity_id": 1,
  "activity_code": "ACT_CA_010",
  "name": "Track conversion funnel",
  "description": "Monitor customer movement from prospect to completed purchase.",
  "activity_type": "ANALYSIS",
  "sequence_order": 3,
  "process_id": 1
}
```

------------------------------------------------------------------------

## 8.2 Classification

Example:

``` json
{
  "category": "ANALYSIS",
  "confidence": 0.9,
  "scores": {
    "ANALYSIS": 6,
    "DECISION": 0,
    "CONTENT": 0
  },
  "matched_keywords": [
    "analysis",
    "monitor",
    "track"
  ]
}
```

------------------------------------------------------------------------

## 8.3 AI Assessment

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

## 8.4 Llama Reasoning

Example structure:

``` json
{
  "provider": "ollama",
  "model": "llama3.2:latest",
  "status": "success",
  "reasoning": {
    "summary": "...",
    "automation_reasoning": "...",
    "augmentation_reasoning": "...",
    "human_role": "...",
    "skill_change": "...",
    "future_outlook": "...",
    "confidence": 0.8
  }
}
```

------------------------------------------------------------------------

## 8.5 Graph Context

The response can include:

``` json
{
  "roles": [],
  "skills": [],
  "cascade_summary": {}
}
```

This represents verified graph context retrieved from PostgreSQL.

------------------------------------------------------------------------

# 9. Runtime Ingestion API

Runtime activity ingestion is exposed under:

``` text
/api/ingestion
```

The ingestion route accepts a new activity and sends it through the
runtime intelligence pipeline.

------------------------------------------------------------------------

## 9.1 Example Request

The current request model uses:

``` json
{
  "process_id": 1,
  "name": "Analyze supplier risk",
  "description": "Evaluate supplier performance, delivery reliability, and commercial risk before contract renewal.",
  "activity_type": "ANALYSIS"
}
```

------------------------------------------------------------------------

## 9.2 Runtime Flow

``` text
POST /api/ingestion/activities
              │
              ▼
       IngestionService
              │
       ┌──────┼────────┐
       ▼      ▼        ▼
    Activity Classify  Analyze
       │      │        │
       └──────┼────────┘
              ▼
       AI Opportunity
              │
              ▼
       Impact Cascade
              │
              ▼
       Llama Reasoning
              │
              ▼
       JSON Response
```

------------------------------------------------------------------------

# 10. Example Ingestion Response

A successful runtime ingestion response can contain:

``` json
{
  "status": "created",
  "activity": {
    "activity_id": 83,
    "activity_code": "ACT_RUNTIME_000083",
    "name": "Analyze customer acquisition risk",
    "description": "Evaluate customer acquisition performance, conversion trends, campaign effectiveness, and potential risks affecting customer growth.",
    "activity_type": "ANALYSIS",
    "automation_level": 75,
    "process_id": 1,
    "sequence_order": 0
  },
  "classification": {},
  "analysis": {},
  "llm_reasoning": {},
  "graph_context": {}
}
```

The exact scores and generated reasoning depend on the activity and
current graph context.

------------------------------------------------------------------------

# 11. AI Analysis vs Runtime Ingestion

These two workflows have different purposes.

### Existing Activity

``` text
GET stored AI analysis
GET cascade
POST runtime reasoning
```

### New Activity

``` text
POST ingestion
     ↓
Create
     ↓
Classify
     ↓
Analyze
     ↓
Opportunity
     ↓
Cascade
     ↓
Reason
```

This distinction is important during a demo.

------------------------------------------------------------------------

# 12. Error Handling

### Activity Not Found

``` http
404 Not Found
```

``` json
{
  "detail": "Activity 85 not found"
}
```

### LLM Unavailable

The deterministic intelligence can remain available while Llama
reasoning reports an unavailable/error state.

Conceptually:

``` text
Classification       ✅
AI Assessment        ✅
AI Opportunity       ✅
Graph Context        ✅
Llama Reasoning      ⚠️
```

This prevents an Ollama failure from invalidating all structured
analysis.

------------------------------------------------------------------------

# 13. Frontend API Usage

The React frontend uses the API to build the intelligence dashboard.

Conceptual sequence:

``` text
User selects activity
        ↓
Frontend requests activity data
        ↓
Frontend requests AI analysis
        ↓
Frontend requests cascade
        ↓
Frontend requests Llama reasoning
        ↓
Frontend renders intelligence
```

The frontend displays:

``` text
AI Assessment
AI Opportunity
Runtime Reasoning
Role Impact
Skill Impact
Related Activities
Future Roles
Future Skills
```

------------------------------------------------------------------------

# 14. API Testing with Swagger

FastAPI automatically provides interactive API documentation.

Open:

``` text
http://127.0.0.1:8000/docs
```

Recommended test order:

``` text
1. GET health
2. GET industries
3. Navigate to process
4. Navigate to activities
5. GET AI analysis
6. GET cascade
7. POST reason
8. POST runtime ingestion
```

Swagger is the authoritative interactive reference for the currently
registered routes and schemas.

------------------------------------------------------------------------

# 15. cURL Examples

### AI Analysis

``` powershell
curl http://127.0.0.1:8000/api/ai-analysis/activities/1
```

### Cascade

``` powershell
curl http://127.0.0.1:8000/api/ai-analysis/activities/1/cascade
```

### Llama Reasoning

``` powershell
curl -X POST http://127.0.0.1:8000/api/ai-analysis/activities/1/reason
```

For Windows PowerShell, Swagger UI can be easier when testing JSON
request bodies.

------------------------------------------------------------------------

# 16. API Design Principles

NovaCart's API follows these principles:

### Thin Routes

Routes coordinate requests rather than containing all business logic.

### Service-Based Logic

Business operations belong in services such as:

``` text
GraphService
ImpactService
IngestionService
```

### Repository-Based Data Access

Graph retrieval is centralized through repository functions.

### Structured Responses

AI information is returned in predictable JSON sections.

### Explicit Failure

Invalid IDs produce explicit HTTP errors rather than silent failures.

------------------------------------------------------------------------

# 17. API Security Note

The current local development API is not presented as
production-secured.

Before production deployment, add:

``` text
Authentication
Authorization
Rate limiting
Input hardening
Secret management
Audit logging
CORS restriction
API gateway / reverse proxy
```

------------------------------------------------------------------------

# 18. Endpoint Summary

  -----------------------------------------------------------------------------------------------------
  Area                    Method                  Endpoint
  ----------------------- ----------------------- -----------------------------------------------------
  Health                  GET                     `/api/health`

  AI analysis             GET                     `/api/ai-analysis/activities/{activity_id}`

  Impact cascade          GET                     `/api/ai-analysis/activities/{activity_id}/cascade`

  Llama reasoning         POST                    `/api/ai-analysis/activities/{activity_id}/reason`

  Runtime ingestion       POST                    `/api/ingestion/activities`

  Enterprise graph        GET                     `/api/industries`

  Enterprise graph        GET                     `/api/processes/...`

  Enterprise graph        GET                     `/api/activities/...`

  Enterprise graph        GET                     `/api/roles/...`

  Enterprise graph        GET                     `/api/skills/...`

  Graph                   GET                     `/api/graph/...`
  -----------------------------------------------------------------------------------------------------

Use `/docs` to inspect the exact registered signatures for the
graph/navigation routes.

------------------------------------------------------------------------

# 19. End-to-End API Contract

The most important intelligence contract is:

``` text
                    ┌──────────────┐
                    │   Activity   │
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ Classification│
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ AI Analysis  │
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ AI Opportunity│
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ Llama Reason │
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ AI Cascade  │
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ React UI    │
                    └──────────────┘
```

This is the primary API-driven intelligence path of NovaCart AI.
