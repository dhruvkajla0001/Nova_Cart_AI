from fastapi import FastAPI

from app.api.routes.activities import router as activities_router
from app.api.routes.health import router as health_router
from app.api.routes.industries import router as industries_router
from app.api.routes.processes import router as processes_router
from app.api.routes.roles import router as roles_router
from app.api.routes.skills import router as skills_router
from app.core.config import get_settings


settings = get_settings()

app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    description=(
        "Process × Role × Skill Intelligence Graph "
        "with AI impact analysis."
    ),
)


app.include_router(health_router)
app.include_router(industries_router)
app.include_router(processes_router)
app.include_router(roles_router)
app.include_router(skills_router)


@app.get("/")
def root():
    return {
        "service": "NovaCart AI",
        "version": settings.app_version,
        "status": "running",
    }