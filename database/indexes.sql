-- ============================================================
-- NovaCart AI
-- Database Performance Indexes
-- ============================================================

BEGIN;

-- Industry
CREATE INDEX IF NOT EXISTS idx_industries_name
    ON industries(name);

-- Value Chains
CREATE INDEX IF NOT EXISTS idx_value_chains_industry
    ON value_chains(industry_id);

CREATE INDEX IF NOT EXISTS idx_value_chains_name
    ON value_chains(name);

-- Processes
CREATE INDEX IF NOT EXISTS idx_processes_value_chain
    ON processes(value_chain_id);

CREATE INDEX IF NOT EXISTS idx_processes_name
    ON processes(name);

-- Activities
CREATE INDEX IF NOT EXISTS idx_activities_process
    ON activities(process_id);

CREATE INDEX IF NOT EXISTS idx_activities_name
    ON activities(name);

CREATE INDEX IF NOT EXISTS idx_activities_type
    ON activities(activity_type);

-- Activity ↔ Role
CREATE INDEX IF NOT EXISTS idx_activity_roles_role
    ON activity_roles(role_id);

-- Role ↔ Skill
CREATE INDEX IF NOT EXISTS idx_role_skills_skill
    ON role_skills(skill_id);

-- Activity ↔ Skill
CREATE INDEX IF NOT EXISTS idx_activity_skills_skill
    ON activity_skills(skill_id);

-- AI Opportunities
CREATE INDEX IF NOT EXISTS idx_ai_opportunities_activity
    ON ai_opportunities(activity_id);

CREATE INDEX IF NOT EXISTS idx_ai_opportunities_status
    ON ai_opportunities(status);

CREATE INDEX IF NOT EXISTS idx_ai_opportunities_type
    ON ai_opportunities(ai_type);

-- AI Impacts
CREATE INDEX IF NOT EXISTS idx_ai_impacts_opportunity
    ON ai_impacts(ai_opportunity_id);

CREATE INDEX IF NOT EXISTS idx_ai_impacts_role
    ON ai_impacts(role_id);

CREATE INDEX IF NOT EXISTS idx_ai_impacts_type
    ON ai_impacts(impact_type);

-- Future Roles
CREATE INDEX IF NOT EXISTS idx_future_roles_base_role
    ON future_roles(role_id);

-- Future Skills
CREATE INDEX IF NOT EXISTS idx_future_skills_base_skill
    ON future_skills(skill_id);

-- Future Role ↔ Future Skill
CREATE INDEX IF NOT EXISTS idx_future_role_skills_skill
    ON future_role_skills(future_skill_id);

-- Evidence
CREATE INDEX IF NOT EXISTS idx_evidence_entity
    ON evidence(entity_type, entity_id);

CREATE INDEX IF NOT EXISTS idx_evidence_source
    ON evidence(source_type);

-- Dynamic / Surprise Records
CREATE INDEX IF NOT EXISTS idx_dynamic_records_entity
    ON dynamic_records(entity_type, entity_id);

CREATE INDEX IF NOT EXISTS idx_dynamic_records_key
    ON dynamic_records(record_key);

CREATE INDEX IF NOT EXISTS idx_dynamic_records_status
    ON dynamic_records(status);

-- JSONB search
CREATE INDEX IF NOT EXISTS idx_dynamic_records_value
    ON dynamic_records USING GIN(record_value);

-- AI Impact Cascade
CREATE INDEX IF NOT EXISTS idx_cascade_source_activity
    ON ai_impact_cascade(source_activity_id);

CREATE INDEX IF NOT EXISTS idx_cascade_source_opportunity
    ON ai_impact_cascade(source_ai_opportunity_id);

CREATE INDEX IF NOT EXISTS idx_cascade_affected_activity
    ON ai_impact_cascade(affected_activity_id);

CREATE INDEX IF NOT EXISTS idx_cascade_affected_role
    ON ai_impact_cascade(affected_role_id);

CREATE INDEX IF NOT EXISTS idx_cascade_affected_skill
    ON ai_impact_cascade(affected_skill_id);

COMMIT;