-- ============================================================
-- NovaCart AI
-- Seed 009: AI Impacts
--
-- AI Opportunity → Activity → Role
--
-- Creates role-level AI impacts for the complete activity graph.
-- ============================================================

BEGIN;

INSERT INTO ai_impacts (
    ai_opportunity_id,
    role_id,
    impact_type,
    impact_score,
    description,
    affected_workload
)

SELECT
    ao.ai_opportunity_id,
    ar.role_id,

    -- --------------------------------------------------------
    -- Impact type
    -- --------------------------------------------------------
    CASE
        WHEN ao.automation_score >= 80
             AND ao.augmentation_score >= 85
            THEN 'AUTOMATION_AUGMENTATION'

        WHEN ao.automation_score >= 75
            THEN 'AUTOMATION'

        WHEN ao.augmentation_score >= 85
            THEN 'AUGMENTATION'

        WHEN ao.ai_type = 'DECISION_SUPPORT'
            THEN 'DECISION_SUPPORT'

        WHEN ao.ai_type = 'AI_ASSISTED_INVESTIGATION'
            THEN 'INVESTIGATION_SUPPORT'

        ELSE
            'AI_ASSISTANCE'
    END,

    -- --------------------------------------------------------
    -- Impact score
    --
    -- Combines automation and augmentation potential.
    -- --------------------------------------------------------
    ROUND(
        (
            COALESCE(ao.automation_score, 0)
            +
            COALESCE(ao.augmentation_score, 0)
        ) / 2.0,
        2
    ),

    -- --------------------------------------------------------
    -- Role-specific reasoning
    -- --------------------------------------------------------
    CASE
        WHEN ao.automation_score >= 85
            THEN
                'High automation potential for activity "'
                || a.name
                || '". The AI opportunity can reduce repetitive '
                || 'workload for the role while shifting human effort '
                || 'toward exception handling, validation, and oversight.'

        WHEN ao.automation_score >= 70
            THEN
                'Moderate-to-high automation potential for activity "'
                || a.name
                || '". AI can automate structured portions of the work '
                || 'while the role focuses on higher-value analysis and supervision.'

        WHEN ao.augmentation_score >= 90
            THEN
                'Strong augmentation opportunity for activity "'
                || a.name
                || '". AI can assist the role with recommendations, '
                || 'analysis, and execution while human judgment remains important.'

        ELSE
            'AI can assist the role in activity "'
            || a.name
            || '" through analysis, recommendations, automation, '
            || 'or decision support.'
    END,

    -- --------------------------------------------------------
    -- Affected workload
    --
    -- Represents the estimated percentage of current workload
    -- that could be changed by the AI opportunity.
    -- --------------------------------------------------------
    ROUND(
        CASE
            WHEN ao.automation_score >= 85
                THEN ao.automation_score * 0.80

            WHEN ao.automation_score >= 70
                THEN ao.automation_score * 0.65

            WHEN ao.augmentation_score >= 90
                THEN ao.augmentation_score * 0.45

            ELSE
                ao.augmentation_score * 0.30
        END,
        2
    )

FROM ai_opportunities ao

JOIN activities a
    ON a.activity_id = ao.activity_id

JOIN activity_roles ar
    ON ar.activity_id = a.activity_id

WHERE NOT EXISTS (
    SELECT 1
    FROM ai_impacts existing
    WHERE existing.ai_opportunity_id = ao.ai_opportunity_id
      AND existing.role_id = ar.role_id
);

COMMIT;