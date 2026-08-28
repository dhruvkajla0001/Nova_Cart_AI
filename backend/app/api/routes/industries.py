from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.graph_service import GraphService


router = APIRouter(
    prefix="/api/industries",
    tags=["Industries"],
)


@router.get("")
def get_industries(
    db: Session = Depends(get_db),
):
    industries = GraphService.get_industries(db)

    return [
        {
            "industry_id": industry.industry_id,
            "industry_code": industry.industry_code,
            "name": industry.name,
            "description": industry.description,
        }
        for industry in industries
    ]


@router.get("/{industry_id}/value-chains")
def get_value_chains(
    industry_id: int,
    db: Session = Depends(get_db),
):
    value_chains = GraphService.get_value_chains(
        db,
        industry_id,
    )

    return [
        {
            "value_chain_id": vc.value_chain_id,
            "value_chain_code": vc.value_chain_code,
            "name": vc.name,
            "description": vc.description,
            "sequence_order": vc.sequence_order,
        }
        for vc in value_chains
    ]