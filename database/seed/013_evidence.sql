-- ============================================================
-- NovaCart AI
-- Seed 013: Evidence
--
-- Provides traceability for:
-- Activities
-- AI Opportunities
-- Future Skills
-- Future Roles
--
-- Evidence is intentionally tied to real database records.
-- ============================================================

BEGIN;


-- ============================================================
-- 1. ACTIVITY EVIDENCE
--
-- Every activity receives baseline process evidence.
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'activity',
    a.activity_id,
    'internal_taxonomy',
    'NovaCart Process Intelligence Dataset',
    a.activity_code,
    'Activity identified as a discrete operational step within the NovaCart value-chain and process taxonomy: '
    || a.name || '.',
    95.00
FROM activities a
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'activity'
      AND e.entity_id = a.activity_id
      AND e.source_reference = a.activity_code
);


-- ============================================================
-- 2. AI OPPORTUNITY EVIDENCE
--
-- Every AI opportunity gets evidence explaining the
-- technology/automation hypothesis.
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'ai_opportunity',
    ao.ai_opportunity_id,
    'AI_assessment',
    'NovaCart AI Intelligence Model',
    ao.name,
    'AI opportunity identified for activity "' || a.name
    || '". Assessment considers the activity type, automation potential, '
    || 'augmentation potential, and suitability for AI-enabled workflow transformation.',
    COALESCE(ao.confidence_score, 85.00)
FROM ai_opportunities ao
JOIN activities a
    ON a.activity_id = ao.activity_id
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'ai_opportunity'
      AND e.entity_id = ao.ai_opportunity_id
      AND e.source_reference = ao.name
);


-- ============================================================
-- 3. AI IMPACT EVIDENCE
--
-- Links evidence to the role affected by an AI opportunity.
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'ai_impact',
    ai.ai_impact_id,
    'impact_assessment',
    'NovaCart AI Impact Model',
    'AI-IMPACT-' || ai.ai_impact_id,
    'AI impact assessed from opportunity "' || ao.name
    || '" on role "' || COALESCE(r.name, 'Unspecified Role')
    || '". Impact considers automation, augmentation, affected workload, '
    || 'and the role responsibilities associated with the activity.',
    CASE
        WHEN ao.confidence_score IS NOT NULL
            THEN ao.confidence_score
        ELSE 85.00
    END
FROM ai_impacts ai
JOIN ai_opportunities ao
    ON ao.ai_opportunity_id = ai.ai_opportunity_id
LEFT JOIN roles r
    ON r.role_id = ai.role_id
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'ai_impact'
      AND e.entity_id = ai.ai_impact_id
);


-- ============================================================
-- 4. FUTURE SKILL EVIDENCE
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'future_skill',
    fs.future_skill_id,
    'future_skill_assessment',
    'NovaCart Future Skills Intelligence Model',
    'FUTURE-SKILL-' || fs.future_skill_id,
    'Future skill "' || fs.name
    || '" represents an emerging or AI-augmented capability associated '
    || 'with changing enterprise work, AI adoption, decision support, '
    || 'automation supervision, or AI-enabled operations.',
    90.00
FROM future_skills fs
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'future_skill'
      AND e.entity_id = fs.future_skill_id
);


-- ============================================================
-- 5. FUTURE ROLE EVIDENCE
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'future_role',
    fr.future_role_id,
    'future_role_assessment',
    'NovaCart Future Workforce Intelligence Model',
    'FUTURE-ROLE-' || fr.future_role_id,
    'Future role "' || fr.name
    || '" represents an AI-enabled evolution of an existing enterprise role '
    || 'or an emerging role created by increasing AI adoption, automation, '
    || 'AI supervision, and model governance requirements.',
    90.00
FROM future_roles fr
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'future_role'
      AND e.entity_id = fr.future_role_id
);


-- ============================================================
-- 6. FUTURE ROLE → FUTURE SKILL EVIDENCE
--
-- Evidence for why a future role requires a future skill.
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'future_role_skill',
    ROW_NUMBER() OVER (
        ORDER BY frs.future_role_id, frs.future_skill_id
    ),
    'future_capability_mapping',
    'NovaCart Future Workforce Intelligence Model',
    'ROLE-SKILL-'
        || frs.future_role_id
        || '-'
        || frs.future_skill_id,
    'Future role "' || fr.name
    || '" is mapped to future skill "' || fs.name
    || '" because the capability supports the transformed responsibilities '
    || 'of the role in an AI-enabled operating environment.',
    91.00
FROM future_role_skills frs
JOIN future_roles fr
    ON fr.future_role_id = frs.future_role_id
JOIN future_skills fs
    ON fs.future_skill_id = frs.future_skill_id
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'future_role_skill'
      AND e.source_reference =
          'ROLE-SKILL-'
          || frs.future_role_id
          || '-'
          || frs.future_skill_id
);


-- ============================================================
-- 7. PROCESS EVIDENCE
--
-- Adds traceability to the process layer.
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'process',
    p.process_id,
    'internal_taxonomy',
    'NovaCart Process Intelligence Dataset',
    p.process_code,
    'Process "' || p.name
    || '" represents a defined business process within the NovaCart '
    || 'value-chain structure and contains operational activities that '
    || 'can be evaluated for AI transformation.',
    95.00
FROM processes p
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'process'
      AND e.entity_id = p.process_id
      AND e.source_reference = p.process_code
);


-- ============================================================
-- 8. ROLE EVIDENCE
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'role',
    r.role_id,
    'internal_taxonomy',
    'NovaCart Workforce Intelligence Dataset',
    r.role_code,
    'Role "' || r.name
    || '" represents a workforce responsibility node connected to '
    || 'activities through the activity-role relationship graph.',
    95.00
FROM roles r
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'role'
      AND e.entity_id = r.role_id
      AND e.source_reference = r.role_code
);


-- ============================================================
-- 9. SKILL EVIDENCE
-- ============================================================

INSERT INTO evidence (
    entity_type,
    entity_id,
    source_type,
    source_name,
    source_reference,
    evidence_text,
    confidence_score
)
SELECT
    'skill',
    s.skill_id,
    'internal_taxonomy',
    'NovaCart Workforce Intelligence Dataset',
    s.skill_code,
    'Skill "' || s.name
    || '" represents a capability required by one or more roles '
    || 'within the NovaCart workforce intelligence graph.',
    95.00
FROM skills s
WHERE NOT EXISTS (
    SELECT 1
    FROM evidence e
    WHERE e.entity_type = 'skill'
      AND e.entity_id = s.skill_id
      AND e.source_reference = s.skill_code
);


COMMIT;