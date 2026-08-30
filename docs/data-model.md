# NovaCart AI --- Data Model

> **Enterprise graph and AI workforce intelligence data model**

This document describes the data model used by NovaCart AI to represent
enterprise structure, AI opportunities, workforce relationships, runtime
records, and AI impact cascades.

The model is designed around one central idea:

``` text
Enterprise Work
      ↓
Activities
      ↓
AI Opportunities
      ↓
Workforce Impact
      ↓
Roles + Skills + Future Capabilities
```

------------------------------------------------------------------------

# 1. Data Model Overview

NovaCart AI represents enterprise intelligence as a connected relational
graph in PostgreSQL.

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
   │
   ├──► Affected Activity
   ├──► Affected Role
   ├──► Affected Skill
   ├──► Future Role
   └──► Future Skill
```

PostgreSQL is the source of truth for these structured enterprise
relationships.

------------------------------------------------------------------------

# 2. Core Entities

The major entities are:

``` text
Industry
Value Chain
Process
Activity
Role
Skill
AI Opportunity
AI Impact Cascade
Dynamic Record
```

The exact relationship tables used to connect these entities are part of
the database schema.

------------------------------------------------------------------------

# 3. Industry

An industry represents a high-level business domain.

Conceptually:

``` text
Industry
   ↓
Value Chain
```

An industry provides the top-level context for enterprise activities.

Examples may include different business sectors represented by the
application's seeded data.

------------------------------------------------------------------------

# 4. Value Chain

A value chain represents a major sequence or area of business value
creation.

Relationship:

``` text
Industry
    │
    └──► Value Chain
```

Value chains provide the layer between the industry and individual
business processes.

------------------------------------------------------------------------

# 5. Process

A process represents a structured business workflow.

Example:

``` text
Process Code:
CA_LEAD_CONVERSION

Process:
Lead Conversion
```

A process can contain multiple activities.

``` text
Process
   ├── Activity 1
   ├── Activity 2
   ├── Activity 3
   └── ...
```

------------------------------------------------------------------------

# 6. Activity

The activity is the central unit of AI analysis.

Typical fields include:

``` text
activity_id
activity_code
name
description
activity_type
automation_level
process_id
sequence_order
```

Example:

``` text
activity_id:
1

activity_code:
ACT_CA_010

name:
Track conversion funnel

description:
Monitor customer movement from prospect to completed purchase.

activity_type:
ANALYSIS

sequence_order:
3

process_id:
1
```

------------------------------------------------------------------------

# 7. Activity as the Intelligence Anchor

The activity is the starting point for the intelligence pipeline.

``` text
Activity
   │
   ├── Classification
   │
   ├── AI Assessment
   │
   ├── AI Opportunity
   │
   ├── Roles
   │
   ├── Skills
   │
   └── Impact Cascade
```

This makes the activity the primary entity selected by the frontend.

------------------------------------------------------------------------

# 8. Activity Type

Activities contain an activity type.

Examples include:

``` text
ANALYSIS
DECISION
CONTENT
OPERATIONS
PLANNING
TECHNICAL
```

The exact allowed values depend on the application's activity schema and
seeded data.

Activity type provides structured context for downstream AI analysis.

------------------------------------------------------------------------

# 9. Role

A role represents a workforce position connected to enterprise work.

Current model:

``` python
class Role(Base):
    __tablename__ = "roles"

    role_id
    role_code
    name
    description
    seniority_level
```

The role model contains:

  Field               Purpose
  ------------------- --------------------------
  `role_id`           Primary identifier
  `role_code`         Unique role code
  `name`              Human-readable role name
  `description`       Role description
  `seniority_level`   Role seniority

------------------------------------------------------------------------

# 10. Role Example

Example role:

``` text
Role Code:
ROLE_CUSTOMER_ACQUISITION_ANALYST

Name:
Customer Acquisition Analyst

Seniority:
ANALYST
```

The role can be connected to multiple activities and skills.

------------------------------------------------------------------------

# 11. Skill

A skill represents a workforce capability.

Current model:

``` python
class Skill(Base):
    __tablename__ = "skills"

    skill_id
    skill_code
    name
    description
    category
    skill_type
```

The skill model contains:

  Field           Purpose
  --------------- -----------------------------------
  `skill_id`      Primary identifier
  `skill_code`    Unique skill code
  `name`          Human-readable skill name
  `description`   Skill definition
  `category`      Business/data/functional category
  `skill_type`    Analytical/technical/etc. type

------------------------------------------------------------------------

# 12. Skill Example

Example:

``` text
Skill Code:
SKILL_DATA_ANALYSIS

Name:
Data Analysis

Category:
DATA

Skill Type:
ANALYTICAL
```

Skills are intentionally modeled separately from roles.

This allows NovaCart AI to answer:

``` text
Which roles are affected?
```

and independently:

``` text
Which capabilities are affected?
```

------------------------------------------------------------------------

# 13. Activity--Role Relationship

An activity can be associated with multiple roles.

Conceptually:

``` text
Activity
   │
   ├────► Role A
   ├────► Role B
   └────► Role C
```

Example:

``` text
Track conversion funnel
       │
       ├── Customer Acquisition Analyst
       └── Marketing Manager
```

This relationship is used by the graph repository when constructing AI
context.

------------------------------------------------------------------------

# 14. Activity--Skill Relationship

An activity can also be associated with multiple skills.

``` text
Activity
   │
   ├────► Data Analysis
   ├────► Marketing Analytics
   └────► Other skills
```

The relationship allows AI impact analysis to move from work to
capabilities.

------------------------------------------------------------------------

# 15. Process--Activity Relationship

Activities belong to processes.

``` text
Process
   │
   ├── Activity
   ├── Activity
   └── Activity
```

The relationship is represented through the activity's:

``` text
process_id
```

The frontend uses this hierarchy for enterprise navigation.

------------------------------------------------------------------------

# 16. AI Opportunity

An AI opportunity represents a potential AI transformation associated
with an activity.

Typical attributes include:

``` text
ai_opportunity_id
activity_id
name
description
ai_type
technology
automation_score
augmentation_score
confidence_score
status
```

Conceptually:

``` text
Activity
    │
    └────► AI Opportunity
```

------------------------------------------------------------------------

# 17. AI Opportunity Example

Example:

``` text
Activity:
Track conversion funnel

AI Opportunity:
AI Automation for Track conversion funnel

AI Type:
INTELLIGENT_AUTOMATION

Technology:
Machine Learning + Analytics

Automation:
81

Augmentation:
95

Confidence:
93
```

The exact values depend on the stored opportunity.

------------------------------------------------------------------------

# 18. AI Opportunity Status

AI opportunities can have a status such as:

``` text
identified
```

The status represents the current lifecycle state of the opportunity.

------------------------------------------------------------------------

# 19. AI Impact Cascade

The impact cascade represents downstream workforce effects caused by an
AI opportunity.

The database model contains:

``` text
ai_impact_cascade
```

with fields including:

``` text
cascade_id
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

# 20. Cascade Primary Key

``` text
cascade_id
```

is the primary key for each impact cascade record.

The identifier is generated by PostgreSQL.

------------------------------------------------------------------------

# 21. Cascade Source Activity

``` text
source_activity_id
```

references the activity from which the impact originates.

Relationship:

``` text
Activity
   │
   └──► Impact Cascade
```

The database uses a foreign key to enforce the relationship.

------------------------------------------------------------------------

# 22. Cascade Source AI Opportunity

``` text
source_ai_opportunity_id
```

identifies the AI opportunity responsible for the transformation.

This relationship can be nullable.

The database is configured so that deleting the source opportunity can
set this reference to `NULL`.

------------------------------------------------------------------------

# 23. Affected Activity

``` text
affected_activity_id
```

identifies another activity affected by the transformation.

This supports secondary activity impacts.

Relationship:

``` text
Source Activity
      ↓
AI Opportunity
      ↓
Affected Activity
```

------------------------------------------------------------------------

# 24. Affected Role

``` text
affected_role_id
```

identifies a workforce role affected by the transformation.

Example:

``` text
Activity
   ↓
AI Opportunity
   ↓
Marketing Manager
```

The relationship is optional because a cascade record may target a skill
or activity instead of a role.

------------------------------------------------------------------------

# 25. Affected Skill

``` text
affected_skill_id
```

identifies a workforce capability affected by the transformation.

Example:

``` text
Activity
   ↓
AI Opportunity
   ↓
Data Analysis
```

The relationship is optional for the same reason as affected roles.

------------------------------------------------------------------------

# 26. Impact Level

``` text
impact_level
```

represents the depth/category of a cascade record.

The database constraint requires:

``` text
impact_level >= 1
```

The application currently interprets cascade levels conceptually as:

``` text
Level 1 → Direct impact
Level 2 → Role / activity impact
Level 3 → Skill impact
Level 4 → Future role impact
Level 5 → Future skill impact
```

The exact mapping of individual records is determined by the
impact-generation logic.

------------------------------------------------------------------------

# 27. Impact Score

``` text
impact_score
```

stores the strength of the impact.

Valid range:

``` text
0 → 100
```

The database enforces this range when the value is not `NULL`.

Frontend representation:

``` text
Impact Score: 75
```

can be displayed as:

``` text
75%
```

------------------------------------------------------------------------

# 28. Impact Reasoning

``` text
reasoning
```

stores the explanation associated with a cascade record.

Example:

``` text
Direct impact: activity "Track conversion funnel"
is affected by AI opportunity "AI Automation for
Track conversion funnel".
Role "Marketing Manager" is directly exposed
to the AI transformation.
```

This makes cascade records explainable rather than being simple
foreign-key relationships.

------------------------------------------------------------------------

# 29. Cascade Timestamps

Each cascade record contains:

``` text
created_at
```

with a PostgreSQL timestamp default.

This provides the time at which the impact record was created.

------------------------------------------------------------------------

# 30. Foreign-Key Behavior

The AI impact cascade uses database-level foreign-key behavior.

### Source Activity

``` text
ON DELETE CASCADE
```

Removing the source activity removes dependent cascade records.

### Source AI Opportunity

``` text
ON DELETE SET NULL
```

Removing the opportunity preserves the cascade record while clearing its
opportunity reference.

### Affected Activity

``` text
ON DELETE CASCADE
```

### Affected Role

``` text
ON DELETE CASCADE
```

### Affected Skill

``` text
ON DELETE CASCADE
```

These constraints keep the cascade data consistent with the entities it
references.

------------------------------------------------------------------------

# 31. Dynamic Records

NovaCart AI also includes a dynamic record structure:

``` text
dynamic_records
```

The purpose is to provide a flexible storage layer for
runtime/discovered information that does not necessarily require a
dedicated relational table immediately.

Fields include:

``` text
dynamic_record_id
entity_type
entity_id
record_key
record_value
source
status
discovered_at
processed_at
```

------------------------------------------------------------------------

# 32. Dynamic Record Value

The field:

``` text
record_value
```

uses PostgreSQL `JSONB`.

This allows flexible structured data.

Conceptually:

``` json
{
  "key": "value",
  "additional_context": "..."
}
```

without requiring a new database column for every possible dynamic
attribute.

------------------------------------------------------------------------

# 33. Dynamic Record Status

Dynamic records default to:

``` text
discovered
```

The status can be used by application logic to represent processing
state.

------------------------------------------------------------------------

# 34. Dynamic Record Timestamps

Dynamic records contain:

``` text
discovered_at
processed_at
```

`discovered_at` defaults to the current PostgreSQL timestamp.

`processed_at` can remain `NULL` until processing occurs.

------------------------------------------------------------------------

# 35. Complete Enterprise Graph

The conceptual enterprise graph is:

``` text
                  INDUSTRY
                     │
                     ▼
                VALUE CHAIN
                     │
                     ▼
                  PROCESS
                     │
                     ▼
                  ACTIVITY
              ┌──────┼──────┐
              ▼      ▼      ▼
            ROLE   SKILL   AI OPPORTUNITY
              │      │          │
              │      │          ▼
              │      │     IMPACT CASCADE
              │      │          │
              │      └──────────┤
              │                 │
              └─────────────────┤
                                ▼
                         WORKFORCE IMPACT
```

------------------------------------------------------------------------

# 36. AI Workforce Graph

The AI-specific graph can be simplified to:

``` text
Activity
   │
   ▼
AI Opportunity
   │
   ▼
Impact
   │
   ├────► Activity
   ├────► Role
   └────► Skill
```

Future workforce intelligence extends this graph:

``` text
Activity
   ↓
AI Opportunity
   ↓
Current Role
   ↓
Current Skill
   ↓
Future Role
   ↓
Future Skill
```

------------------------------------------------------------------------

# 37. Data Flow Through the Model

When an existing activity is analyzed:

``` text
Activity
   │
   ├──► Process
   │
   ├──► Roles
   │
   ├──► Skills
   │
   └──► AI Opportunity
              │
              ▼
        Impact Cascade
```

The resulting entities are assembled into the API response.

------------------------------------------------------------------------

# 38. Runtime Data Flow

When a new activity is ingested:

``` text
Runtime Request
      │
      ▼
Create Activity
      │
      ▼
Persist Activity
      │
      ▼
Classify
      │
      ▼
AI Assessment
      │
      ▼
Create AI Opportunity
      │
      ▼
Create / Resolve Impact
      │
      ▼
Llama Reasoning
```

The exact orchestration belongs to the ingestion/service layer.

------------------------------------------------------------------------

# 39. Data Model and AI Separation

The data model intentionally separates stored facts from generated
reasoning.

### Stored / structured data

``` text
Activity
Process
Role
Skill
AI Opportunity
Impact Cascade
Dynamic Record
```

### Generated runtime reasoning

``` text
Llama summary
Automation reasoning
Augmentation reasoning
Human role
Skill change
Future outlook
```

The LLM response is not treated as a replacement for the structured
database graph.

------------------------------------------------------------------------

# 40. Data Model and Explainability

The relationships make it possible to explain an AI assessment using
traceable entities.

For example:

``` text
Why is this activity important?
        ↓
Because it belongs to Process X.

Why is AI relevant?
        ↓
Because an AI Opportunity is associated with it.

Who is affected?
        ↓
Roles connected to the activity.

What capabilities are affected?
        ↓
Skills connected to the activity.

What could happen next?
        ↓
Impact cascade and future workforce records.
```

------------------------------------------------------------------------

# 41. Data Integrity

The model uses PostgreSQL constraints to protect important
relationships.

Examples:

``` text
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
DEFAULT
```

The impact model specifically enforces:

``` text
impact_level >= 1
```

and:

``` text
0 <= impact_score <= 100
```

when an impact score exists.

------------------------------------------------------------------------

# 42. ORM Mapping

The application uses SQLAlchemy ORM models.

Conceptually:

``` text
Python Model
      ↓
SQLAlchemy ORM
      ↓
PostgreSQL Table
```

Examples:

``` text
Role
  ↓
roles

Skill
  ↓
skills

AIImpactCascade
  ↓
ai_impact_cascade
```

This allows the service layer to work with typed Python entities while
PostgreSQL remains the persistent source of truth.

------------------------------------------------------------------------

# 43. Data Access Pattern

NovaCart AI follows:

``` text
API Route
    ↓
Service
    ↓
Repository
    ↓
SQLAlchemy
    ↓
PostgreSQL
```

The frontend does not access PostgreSQL directly.

------------------------------------------------------------------------

# 44. Frontend Data Model

The React application consumes API-shaped data rather than database rows
directly.

A reasoning response is conceptually:

``` json
{
  "activity": {},
  "classification": {},
  "analysis": {},
  "llm_reasoning": {},
  "graph_context": {}
}
```

A cascade response is conceptually:

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

The frontend normalizes these structures for visualization.

------------------------------------------------------------------------

# 45. Example End-to-End Record

For:

``` text
Activity:
Track conversion funnel
```

the data model can connect:

``` text
Process
  Lead Conversion
       │
       ▼
Activity
  Track conversion funnel
       │
       ├───────────────┐
       ▼               ▼
Roles              Skills
       │               │
       ▼               ▼
Marketing Manager   Data Analysis
Customer Acquisition
Analyst             Marketing Analytics
       │
       ▼
AI Opportunity
  Intelligent Automation
       │
       ▼
Impact Cascade
       │
       ├── Roles
       ├── Skills
       ├── Activities
       ├── Future Roles
       └── Future Skills
```

------------------------------------------------------------------------

# 46. Data Model Design Goals

The model is designed to support:

### Enterprise Navigation

``` text
Industry → Value Chain → Process → Activity
```

### Workforce Mapping

``` text
Activity → Role
Activity → Skill
```

### AI Transformation

``` text
Activity → AI Opportunity
```

### Workforce Impact

``` text
AI Opportunity → Impact Cascade
```

### Runtime Extensibility

``` text
New Activity → Dynamic / Runtime Intelligence
```

------------------------------------------------------------------------

# 47. Current Data Model Status

  Entity / Capability      Status
  ------------------------ --------
  Industry                 ✅
  Value Chain              ✅
  Process                  ✅
  Activity                 ✅
  Role                     ✅
  Skill                    ✅
  Activity relationships   ✅
  AI Opportunity           ✅
  AI Impact Cascade        ✅
  Dynamic Records          ✅
  PostgreSQL constraints   ✅
  SQLAlchemy models        ✅
  Runtime ingestion        ✅
  Frontend visualization   ✅

------------------------------------------------------------------------

# 48. Future Data Model Extensions

Potential future additions include:

``` text
Workforce Transition
Skill Gap
Role Skill Matrix
AI Opportunity Priority
Business Impact
ROI Estimate
Model Evaluation
Historical Assessment
Assessment Version
Audit Event
Tenant
User
```

These are future extensions and are not assumed to exist in the current
schema.

------------------------------------------------------------------------

# 49. Data Model Summary

NovaCart AI's data model can be summarized as:

``` text
             ENTERPRISE STRUCTURE
                     │
                     ▼
               ┌──────────┐
               │ Activity │
               └────┬─────┘
                    │
          ┌─────────┼─────────┐
          ▼         ▼         ▼
        Roles     Skills   AI Opportunity
                              │
                              ▼
                        Impact Cascade
                              │
                 ┌────────────┼────────────┐
                 ▼            ▼            ▼
              Activities     Roles       Skills
                 │
                 ▼
            Future Workforce
```

The central principle is:

> **Activities represent the work, the enterprise graph provides the
> context, AI opportunities represent possible transformation, and the
> impact cascade connects that transformation to workforce roles and
> capabilities.**
