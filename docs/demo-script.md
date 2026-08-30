# NovaCart AI --- Demo Script

> **Recruiter / Technical Interview Demo Guide**

This script is designed for a short, polished demonstration of NovaCart
AI.

Recommended demo duration:

``` text
3–5 minutes
```

The goal is to demonstrate the complete intelligence pipeline rather
than explain every implementation detail.

------------------------------------------------------------------------

# 1. Demo Objective

The demo should answer one simple question:

> **What happens to enterprise work when AI is introduced?**

Show that NovaCart AI can move from:

``` text
Enterprise Activity
        ↓
AI Opportunity
        ↓
AI Reasoning
        ↓
Workforce Impact
```

------------------------------------------------------------------------

# 2. Before the Demo

Start the required services.

### Backend

``` powershell
cd D:\Nova_Cart_AI\backend
uvicorn app.main:app --reload
```

Expected:

``` text
Uvicorn running on http://127.0.0.1:8000
Application startup complete.
```

### Frontend

Open another terminal:

``` powershell
cd D:\Nova_Cart_AI\frontend
npm run dev
```

Open the Vite URL shown by the terminal.

### Ollama

Make sure Ollama is running and the expected local model is available:

``` text
llama3.2:latest
```

------------------------------------------------------------------------

# 3. Quick Health Check

Before opening the dashboard, verify:

``` text
http://127.0.0.1:8000/docs
```

If Swagger opens, the FastAPI backend is running.

Then verify that the frontend loads.

------------------------------------------------------------------------

# 4. Demo Story

Use this narrative:

> "NovaCart AI is an enterprise workforce intelligence platform. Instead
> of asking only whether AI can automate a task, it connects the task to
> the enterprise graph, evaluates automation and augmentation potential,
> uses a local Llama model to explain the transformation, and then
> traces the impact across roles, skills, and future workforce
> capabilities."

Then start the dashboard.

------------------------------------------------------------------------

# 5. Demo Step 1 --- Enterprise Graph

Show the navigation hierarchy:

``` text
Industry
   ↓
Value Chain
   ↓
Process
   ↓
Activity
```

Say:

> "The system starts with structured enterprise data. PostgreSQL acts as
> the source of truth for the enterprise graph."

Select a real activity.

Recommended example:

``` text
Track conversion funnel
```

------------------------------------------------------------------------

# 6. Demo Step 2 --- Activity

Show:

``` text
Track conversion funnel
```

Description:

``` text
Monitor customer movement from prospect
to completed purchase.
```

Say:

> "This is an activity inside the enterprise process graph. Everything
> downstream is driven from this activity."

------------------------------------------------------------------------

# 7. Demo Step 3 --- Classification

Show the classification section.

Example:

``` text
ANALYSIS

Confidence:
90%
```

Say:

> "First, a deterministic classifier identifies what kind of work this
> is. This is deliberately not delegated entirely to the LLM."

Point out:

``` text
Matched keywords:
analysis
monitor
track
```

------------------------------------------------------------------------

# 8. Demo Step 4 --- AI Assessment

Show:

``` text
Automation:      81%
Augmentation:    95%
AI Mode:         HIGH_AUTOMATION
Confidence:      98%
```

Say:

> "Next, the AI analyzer estimates both automation and augmentation
> potential. I want to distinguish these because enterprise AI does not
> always mean replacing the person doing the work."

This is an important talking point.

------------------------------------------------------------------------

# 9. Demo Step 5 --- AI Opportunity

Show:

``` text
AI Automation for Track conversion funnel
```

And:

``` text
AI Type:
INTELLIGENT_AUTOMATION

Technology:
Machine Learning + Analytics
```

Say:

> "The structured assessment resolves into an AI opportunity that is
> persisted in the system."

------------------------------------------------------------------------

# 10. Demo Step 6 --- Llama 3.2

Open the runtime reasoning section.

Show:

``` text
Llama 3.2 Analysis
```

Then show:

``` text
Summary
Automation reasoning
Augmentation reasoning
Human role
Skill change
Future outlook
```

Say:

> "Now we bring in the local Llama 3.2 model through Ollama. The model
> is not discovering the enterprise graph. It receives verified
> activity, AI assessment, roles, skills, and cascade context and
> explains what the transformation means."

This is one of the strongest technical points of the demo.

------------------------------------------------------------------------

# 11. Demo Step 7 --- Human Role

Scroll to the human-role reasoning.

Say:

> "Notice that the system doesn't simply say 'AI replaces this role'. It
> reasons about which responsibilities remain human and how the human
> role changes."

This demonstrates the workforce-intelligence angle.

------------------------------------------------------------------------

# 12. Demo Step 8 --- Skill Change

Show the skill-change reasoning.

Say:

> "The platform also considers how skills evolve. That makes the system
> useful for workforce planning rather than only automation analysis."

------------------------------------------------------------------------

# 13. Demo Step 9 --- Impact Cascade

Scroll to:

``` text
AI Impact Cascade
```

Show:

``` text
Total impacts
Roles affected
Skills affected
Related activities
Future roles
Future skills
```

Say:

> "This is where NovaCart goes beyond an AI score. The impact engine
> propagates the transformation through the workforce graph."

Then explain:

``` text
Activity
   ↓
Role
   ↓
Skill
   ↓
Related Work
   ↓
Future Role
   ↓
Future Skill
```

------------------------------------------------------------------------

# 14. Demo Step 10 --- Role Impact

Show the affected roles.

Say:

> "These are roles connected to the activity through the enterprise
> graph. The impact engine can attach an impact score and reasoning to
> the transformation."

------------------------------------------------------------------------

# 15. Demo Step 11 --- Skill Impact

Show the skills.

Say:

> "The same transformation can affect capabilities independently of job
> titles. That's why the platform tracks skills as a separate graph
> dimension."

------------------------------------------------------------------------

# 16. Demo Step 12 --- Future Workforce

Show:

``` text
Future Roles
Future Skills
```

Say:

> "Finally, the cascade can extend toward future roles and skills,
> giving the organization a forward-looking workforce view."

------------------------------------------------------------------------

# 17. Demo Step 13 --- Surprise Record

Now demonstrate runtime intelligence.

Open the runtime activity ingestion area.

Enter:

``` text
Name:
Analyze supplier risk
```

Description:

``` text
Evaluate supplier performance, delivery reliability,
and commercial risk before contract renewal.
```

Type:

``` text
ANALYSIS
```

Process:

``` text
1
```

Submit.

------------------------------------------------------------------------

# 18. Runtime Demo Narrative

While it processes, say:

> "This is the part I use to demonstrate that the system is not just a
> static dashboard. I'm introducing a new activity at runtime."

Then explain:

``` text
INGEST
  ↓
CLASSIFY
  ↓
ASSESS
  ↓
AI OPPORTUNITY
  ↓
LLAMA
  ↓
IMPACT CASCADE
```

------------------------------------------------------------------------

# 19. Runtime Result

Show the returned activity.

Example:

``` text
Analyze supplier risk
```

Then show:

``` text
Classification
AI Assessment
AI Opportunity
Llama Reasoning
Graph Context
```

Say:

> "The new activity is processed through the same intelligence pipeline
> and returned as structured intelligence."

------------------------------------------------------------------------

# 20. If Llama Is Slow

Do not panic.

Say:

> "The deterministic assessment is independent of the local LLM, so the
> structured intelligence is still available while the local model
> completes its reasoning."

Then wait for the result.

------------------------------------------------------------------------

# 21. If Llama Is Unavailable

If the UI displays:

``` text
LLM unavailable
```

say:

> "The local reasoning layer is currently unavailable, but the
> deterministic AI assessment remains functional. That's intentional
> architectural separation."

Then continue showing:

``` text
Classification
Automation
Augmentation
AI Opportunity
Impact
```

Do not restart the entire application unless necessary.

------------------------------------------------------------------------

# 22. If an Activity ID Is Invalid

If you see:

``` json
{
  "detail": "Activity 85 not found"
}
```

say:

> "That's a normal API-level 404 because the requested activity doesn't
> exist. The frontend should use the selected activity ID from the
> graph."

Then return to a valid activity.

------------------------------------------------------------------------

# 23. Technical Architecture Explanation

If the interviewer asks:

> "How does this work internally?"

Answer:

> "The frontend is React and communicates with FastAPI over REST.
> FastAPI uses services and repositories to retrieve the enterprise
> graph from PostgreSQL. The activity first goes through deterministic
> classification and AI assessment. Stored AI opportunities are then
> resolved. For contextual explanation, the application passes the
> structured activity, assessment, roles, skills, and cascade context to
> a locally hosted Llama 3.2 model through Ollama. Finally, the
> ImpactService resolves the workforce cascade and the React frontend
> visualizes it."

------------------------------------------------------------------------

# 24. If Asked Why PostgreSQL

Answer:

> "I wanted the enterprise graph to remain deterministic and queryable.
> PostgreSQL gives me strong relational constraints, SQLAlchemy
> integration, and a straightforward local development setup. The LLM is
> not the source of truth for graph relationships."

------------------------------------------------------------------------

# 25. If Asked Why Llama

Answer:

> "I use Llama 3.2 locally through Ollama for the natural-language
> reasoning layer. The model explains structured intelligence instead of
> being responsible for discovering enterprise facts."

------------------------------------------------------------------------

# 26. If Asked Why Not Let the LLM Do Everything?

Answer:

> "Because an LLM can generate plausible but incorrect relationships. I
> wanted enterprise facts and relationships to come from PostgreSQL and
> deterministic application logic. The LLM is then used where generative
> reasoning provides value."

------------------------------------------------------------------------

# 27. If Asked What Is Unique?

Answer:

> "The important part is the impact cascade. The system doesn't stop at
> 'this activity has 80% automation potential'. It asks what that
> transformation means for connected roles, skills, related activities,
> future roles, and future skills."

------------------------------------------------------------------------

# 28. If Asked About Human Replacement

Answer:

> "The platform separates automation from augmentation. A high
> automation score doesn't automatically mean complete job replacement.
> The LLM also reasons about the human role that remains and how skills
> may change."

------------------------------------------------------------------------

# 29. If Asked About Hallucinations

Answer:

> "The architecture limits the LLM's authority. PostgreSQL is the source
> of truth for enterprise entities and relationships. The deterministic
> layer calculates structured scores. The LLM receives that verified
> context and is primarily responsible for contextual explanation."

------------------------------------------------------------------------

# 30. If Asked About Production Readiness

Answer honestly:

> "The core intelligence pipeline is working, but I would add production
> authentication, authorization, multi-tenancy, rate limiting, stronger
> observability, automated testing, deployment infrastructure, and model
> evaluation before treating it as a production enterprise system."

Do not claim features that are not currently implemented.

------------------------------------------------------------------------

# 31. 30-Second Pitch

Use this if the recruiter asks:

> "What did you build?"

Answer:

> "I built NovaCart AI, an enterprise AI workforce intelligence
> platform. It models enterprise activities, processes, roles, and
> skills in PostgreSQL, uses deterministic AI to estimate automation and
> augmentation potential, uses a locally hosted Llama 3.2 model through
> Ollama for contextual reasoning, and then traces the AI transformation
> through an impact cascade covering roles, skills, related activities,
> future roles, and future skills. I built the backend with FastAPI and
> the dashboard with React."

------------------------------------------------------------------------

# 32. 60-Second Technical Pitch

> "The architecture is intentionally layered. PostgreSQL is the source
> of truth for the enterprise graph. FastAPI exposes graph, activity,
> AI-analysis, and ingestion APIs. An activity first passes through a
> deterministic classifier and AI analyzer, which produce
> classification, automation, augmentation, and AI opportunity data. The
> graph repository then supplies roles and skills. That structured
> context is passed to a local Llama 3.2 model through Ollama for
> reasoning around automation, augmentation, human responsibilities,
> skill changes, and future outlook. Finally, the ImpactService
> generates or retrieves workforce cascade information, and React
> visualizes the entire intelligence chain. I also support runtime
> ingestion so a new activity can enter the pipeline without being
> hardcoded into the UI."

------------------------------------------------------------------------

# 33. Demo Checklist

Before the recruiter call:

``` text
[ ] PostgreSQL running
[ ] Ollama running
[ ] Llama 3.2 available
[ ] FastAPI running
[ ] Frontend running
[ ] Swagger opens
[ ] Existing activity loads
[ ] AI assessment appears
[ ] Llama reasoning appears
[ ] Cascade appears
[ ] Runtime ingestion works
[ ] Browser console has no blocking errors
```

------------------------------------------------------------------------

# 34. Recommended Demo Activity

For the safest demo, use an activity that already has complete graph
context and stored AI intelligence.

Recommended:

``` text
Track conversion funnel
```

It has demonstrated:

``` text
Classification
AI Assessment
AI Opportunity
Llama Reasoning
Roles
Skills
Impact Cascade
```

Use runtime ingestion only after the main flow is already demonstrated.

------------------------------------------------------------------------

# 35. Final Demo Sequence

The complete polished sequence should be:

``` text
OPEN DASHBOARD
      ↓
SELECT PROCESS
      ↓
SELECT ACTIVITY
      ↓
SHOW AI ASSESSMENT
      ↓
SHOW AI OPPORTUNITY
      ↓
SHOW LLAMA REASONING
      ↓
SHOW IMPACT CASCADE
      ↓
SHOW ROLES
      ↓
SHOW SKILLS
      ↓
SHOW FUTURE WORKFORCE
      ↓
RUN SURPRISE RECORD
      ↓
SHOW RUNTIME INTELLIGENCE
```

------------------------------------------------------------------------

# 36. Closing Statement

End with:

> "The goal of NovaCart AI is not simply to predict whether AI can
> automate work. It's to connect AI transformation to the enterprise
> workforce graph and make the resulting changes understandable at the
> activity, role, skill, and future-workforce levels."

Then stop.

Do not continue clicking through unrelated features unless the
interviewer asks.

------------------------------------------------------------------------

# 37. Golden Rule

During the demo:

``` text
Don't explain everything.

Show:
    Activity
       ↓
    AI Opportunity
       ↓
    Llama Reasoning
       ↓
    Impact Cascade
       ↓
    Workforce Change
```

That is the story of NovaCart AI.
