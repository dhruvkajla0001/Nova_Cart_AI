-- ============================================================
-- NovaCart AI
-- Seed 014: AI Impact Cascade
--
-- Cascade:
--
-- Activity
--    ↓
-- AI Opportunity
--    ↓
-- AI Impact
--    ↓
-- Affected Role
--    ↓
-- Affected Skill
--    ↓
-- Future Role / Future Skill reasoning
--
-- IMPORTANT:
-- affected_role_id references roles(role_id)
-- affected_skill_id references skills(skill_id)
--
-- Therefore future role/skill IDs are NOT stored in those
-- columns. Future transformations are described in reasoning.
-- ============================================================

BEGIN;


-- ============================================================
-- LEVEL 1
-- DIRECT ACTIVITY → AI OPPORTUNITY → ROLE → SKILL
-- ============================================================

INSERT INTO ai_impact_cascade (
    source_activity_id,
    source_ai_opportunity_id,
    affected_activity_id,
    affected_role_id,
    affected_skill_id,
    impact_level,
    impact_score,
    reasoning
)
SELECT DISTINCT
    ao.activity_id,
    ao.ai_opportunity_id,
    ao.activity_id,
    ai.role_id,
    rs.skill_id,
    1,
    LEAST(
        100.00,
        COALESCE(
            ai.impact_score,
            ao.automation_score,
            ao.augmentation_score,
            50.00
        )
    ),
    'Direct impact: activity "'
    || a.name
    || '" is affected by AI opportunity "'
    || ao.name
    || '". Role "'
    || r.name
    || '" and skill "'
    || s.name
    || '" are directly exposed to the AI transformation.'
FROM ai_opportunities ao
JOIN activities a
    ON a.activity_id = ao.activity_id
JOIN ai_impacts ai
    ON ai.ai_opportunity_id = ao.ai_opportunity_id
JOIN roles r
    ON r.role_id = ai.role_id
JOIN role_skills rs
    ON rs.role_id = r.role_id
JOIN skills s
    ON s.skill_id = rs.skill_id
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_impact_cascade c
    WHERE c.source_ai_opportunity_id = ao.ai_opportunity_id
      AND c.affected_activity_id = ao.activity_id
      AND c.affected_role_id = ai.role_id
      AND c.affected_skill_id = rs.skill_id
      AND c.impact_level = 1
);


-- ============================================================
-- LEVEL 2
-- ROLE → OTHER ACTIVITIES
--
-- If AI changes one activity performed by a role,
-- other activities performed by that role can also be affected.
-- ============================================================

INSERT INTO ai_impact_cascade (
    source_activity_id,
    source_ai_opportunity_id,
    affected_activity_id,
    affected_role_id,
    affected_skill_id,
    impact_level,
    impact_score,
    reasoning
)
SELECT DISTINCT
    ao.activity_id,
    ao.ai_opportunity_id,
    affected_a.activity_id,
    ai.role_id,
    NULL::bigint,
    2,
    LEAST(
        100.00,
        COALESCE(
            ai.impact_score,
            ao.automation_score,
            50.00
        ) * 0.75
    ),
    'Role cascade: AI transformation of activity "'
    || source_a.name
    || '" affects role "'
    || r.name
    || '". The same role also performs activity "'
    || affected_a.name
    || '", so changes in workload, responsibilities, or workflow may propagate.'
FROM ai_opportunities ao
JOIN activities source_a
    ON source_a.activity_id = ao.activity_id
JOIN ai_impacts ai
    ON ai.ai_opportunity_id = ao.ai_opportunity_id
JOIN roles r
    ON r.role_id = ai.role_id
JOIN activity_roles ar
    ON ar.role_id = r.role_id
JOIN activities affected_a
    ON affected_a.activity_id = ar.activity_id
WHERE affected_a.activity_id <> ao.activity_id
AND NOT EXISTS (
    SELECT 1
    FROM ai_impact_cascade c
    WHERE c.source_ai_opportunity_id = ao.ai_opportunity_id
      AND c.affected_activity_id = affected_a.activity_id
      AND c.affected_role_id = ai.role_id
      AND c.impact_level = 2
);


-- ============================================================
-- LEVEL 3
-- ROLE → CURRENT SKILLS
--
-- The AI transformation can change the importance of skills
-- required by the affected role.
-- ============================================================

INSERT INTO ai_impact_cascade (
    source_activity_id,
    source_ai_opportunity_id,
    affected_activity_id,
    affected_role_id,
    affected_skill_id,
    impact_level,
    impact_score,
    reasoning
)
SELECT DISTINCT
    ao.activity_id,
    ao.ai_opportunity_id,
    ao.activity_id,
    ai.role_id,
    rs.skill_id,
    3,
    LEAST(
        100.00,
        COALESCE(
            ai.impact_score,
            ao.augmentation_score,
            ao.automation_score,
            50.00
        ) * 0.65
    ),
    'Skill cascade: AI transformation of activity "'
    || a.name
    || '" affects role "'
    || r.name
    || '". Current skill "'
    || s.name
    || '" may require AI augmentation, validation, supervision, '
    || 'or reskilling.'
FROM ai_opportunities ao
JOIN activities a
    ON a.activity_id = ao.activity_id
JOIN ai_impacts ai
    ON ai.ai_opportunity_id = ao.ai_opportunity_id
JOIN roles r
    ON r.role_id = ai.role_id
JOIN role_skills rs
    ON rs.role_id = r.role_id
JOIN skills s
    ON s.skill_id = rs.skill_id
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_impact_cascade c
    WHERE c.source_ai_opportunity_id = ao.ai_opportunity_id
      AND c.affected_activity_id = ao.activity_id
      AND c.affected_role_id = ai.role_id
      AND c.affected_skill_id = rs.skill_id
      AND c.impact_level = 3
);


-- ============================================================
-- LEVEL 4
-- CURRENT ROLE → FUTURE ROLE
--
-- affected_role_id remains the CURRENT role because of the FK.
-- Future role information is stored in reasoning.
-- ============================================================

INSERT INTO ai_impact_cascade (
    source_activity_id,
    source_ai_opportunity_id,
    affected_activity_id,
    affected_role_id,
    affected_skill_id,
    impact_level,
    impact_score,
    reasoning
)
SELECT DISTINCT
    ao.activity_id,
    ao.ai_opportunity_id,
    ao.activity_id,
    current_r.role_id,
    NULL::bigint,
    4,
    LEAST(
        100.00,
        COALESCE(
            fr.emergence_score,
            ai.impact_score,
            50.00
        ) * 0.55
    ),
    'Future-role cascade: activity "'
    || a.name
    || '" affects current role "'
    || current_r.name
    || '". The role has a future evolution toward "'
    || fr.name
    || '" with an emergence score of '
    || COALESCE(fr.emergence_score::text, 'N/A')
    || '.'
FROM ai_opportunities ao
JOIN activities a
    ON a.activity_id = ao.activity_id
JOIN ai_impacts ai
    ON ai.ai_opportunity_id = ao.ai_opportunity_id
JOIN roles current_r
    ON current_r.role_id = ai.role_id
JOIN future_roles fr
    ON fr.role_id = current_r.role_id
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_impact_cascade c
    WHERE c.source_ai_opportunity_id = ao.ai_opportunity_id
      AND c.affected_activity_id = ao.activity_id
      AND c.affected_role_id = current_r.role_id
      AND c.impact_level = 4
);


-- ============================================================
-- LEVEL 5
-- CURRENT SKILL → FUTURE SKILL
--
-- affected_skill_id remains the CURRENT skill because of FK.
-- Future skill information is stored in reasoning.
-- ============================================================

INSERT INTO ai_impact_cascade (
    source_activity_id,
    source_ai_opportunity_id,
    affected_activity_id,
    affected_role_id,
    affected_skill_id,
    impact_level,
    impact_score,
    reasoning
)
SELECT DISTINCT
    ao.activity_id,
    ao.ai_opportunity_id,
    ao.activity_id,
    current_r.role_id,
    current_rs.skill_id,
    5,
    LEAST(
        100.00,
        COALESCE(
            frs.importance,
            future_s.demand_score,
            ai.impact_score,
            50.00
        ) * 0.50
    ),
    'Future-skill cascade: activity "'
    || a.name
    || '" changes the capability requirements of role "'
    || current_r.name
    || '". Current skill "'
    || current_s.name
    || '" evolves toward future role "'
    || fr.name
    || '" and future skill "'
    || future_s.name
    || '". Future skill demand score is '
    || COALESCE(future_s.demand_score::text, 'N/A')
    || ' and importance is '
    || COALESCE(frs.importance::text, 'N/A')
    || '.'
FROM ai_opportunities ao
JOIN activities a
    ON a.activity_id = ao.activity_id
JOIN ai_impacts ai
    ON ai.ai_opportunity_id = ao.ai_opportunity_id
JOIN roles current_r
    ON current_r.role_id = ai.role_id
JOIN role_skills current_rs
    ON current_rs.role_id = current_r.role_id
JOIN skills current_s
    ON current_s.skill_id = current_rs.skill_id
JOIN future_roles fr
    ON fr.role_id = current_r.role_id
JOIN future_role_skills frs
    ON frs.future_role_id = fr.future_role_id
JOIN future_skills future_s
    ON future_s.future_skill_id = frs.future_skill_id
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_impact_cascade c
    WHERE c.source_ai_opportunity_id = ao.ai_opportunity_id
      AND c.affected_activity_id = ao.activity_id
      AND c.affected_role_id = current_r.role_id
      AND c.affected_skill_id = current_rs.skill_id
      AND c.impact_level = 5
);


COMMIT;