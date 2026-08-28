from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes.health import router as health_router
from app.api.routes.industries import router as industries_router
from app.api.routes.processes import router as processes_router
from app.api.routes.roles import router as roles_router
from app.api.routes.skills import router as skills_router
from app.api.routes.activities import router as activities_router
from app.api.routes.graph import router as graph_router
from app.api.routes.ai_analysis import router as ai_analysis_router


app = FastAPI(
    title="NovaCart AI",
    description="Enterprise AI Workforce Intelligence Platform",
    version="1.0.0",
)


# ============================================================
# CORS
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# ROUTES
# ============================================================

app.include_router(health_router)
app.include_router(industries_router)
app.include_router(processes_router)
app.include_router(roles_router)
app.include_router(skills_router)
app.include_router(activities_router)
app.include_router(graph_router)
app.include_router(ai_analysis_router)


# ============================================================
# ROOT
# ============================================================

@app.get("/")
def root():
    return {
        "name": "NovaCart AI",
        "description": "Enterprise AI Workforce Intelligence Platform",
        "status": "running",
        "version": "1.0.0",
    }