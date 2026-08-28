-- ============================================================
-- NovaCart AI
-- Seed 008: AI Opportunities
--
-- Creates ONE AI opportunity for EVERY activity.
-- Total expected: 80
--
-- The opportunity is derived from:
--   activities.name
--   activities.activity_type
--   activities.automation_level
--
-- This makes the AI layer data-driven rather than hardcoded
-- to a small subset of activities.
-- ============================================================

BEGIN;

INSERT INTO ai_opportunities (
    activity_id,
    name,
    description,
    ai_type,
    technology,
    automation_score,
    augmentation_score,
    confidence_score,
    status
)
SELECT
    a.activity_id,

    -- --------------------------------------------------------
    -- Opportunity name
    -- --------------------------------------------------------
    CASE
        WHEN a.activity_type = 'PHYSICAL_OPERATION'
            THEN 'AI-Assisted ' || a.name

        WHEN a.activity_type = 'DECISION_MAKING'
            THEN 'AI Decision Support for ' || a.name

        WHEN a.activity_type = 'EXCEPTION_HANDLING'
            THEN 'AI Exception Intelligence for ' || a.name

        WHEN a.activity_type = 'COMMUNICATION'
            THEN 'AI-Assisted ' || a.name

        WHEN a.activity_type = 'CREATIVE'
            THEN 'Generative AI for ' || a.name

        WHEN a.activity_type = 'RECOMMENDATION'
            THEN 'AI Recommendation Engine for ' || a.name

        WHEN a.activity_type = 'PREDICTION'
            THEN 'AI Prediction for ' || a.name

        WHEN a.activity_type = 'RISK_ANALYSIS'
            THEN 'AI Risk Intelligence for ' || a.name

        WHEN a.activity_type = 'ANOMALY_DETECTION'
            THEN 'AI Anomaly Detection for ' || a.name

        ELSE
            'AI Automation for ' || a.name
    END,

    -- --------------------------------------------------------
    -- Description
    -- --------------------------------------------------------
    CASE
        WHEN a.activity_type = 'PHYSICAL_OPERATION'
            THEN
                'Use AI to assist this physical activity through '
                || 'intelligent instructions, optimization, monitoring, '
                || 'and human-in-the-loop decision support.'

        WHEN a.activity_type = 'DECISION_MAKING'
            THEN
                'Use AI to analyze relevant business context, '
                || 'recommend decisions, and surface risks while '
                || 'keeping final accountability with the human role.'

        WHEN a.activity_type = 'EXCEPTION_HANDLING'
            THEN
                'Use AI to detect, classify, investigate, and recommend '
                || 'resolution paths for operational exceptions.'

        WHEN a.activity_type = 'COMMUNICATION'
            THEN
                'Use AI to automate routine communication and generate '
                || 'context-aware responses while allowing human escalation.'

        WHEN a.activity_type = 'CREATIVE'
            THEN
                'Use generative AI to create initial content variations '
                || 'and accelerate creative production with human review.'

        WHEN a.activity_type = 'RECOMMENDATION'
            THEN
                'Use AI models to generate recommendations from '
                || 'historical data, behavioral signals, and business constraints.'

        WHEN a.activity_type = 'PREDICTION'
            THEN
                'Use machine learning to predict future outcomes from '
                || 'historical patterns and current operational signals.'

        WHEN a.activity_type = 'RISK_ANALYSIS'
            THEN
                'Use machine learning to evaluate risk signals, '
                || 'identify high-risk cases, and support risk decisions.'

        WHEN a.activity_type = 'ANOMALY_DETECTION'
            THEN
                'Use AI to continuously identify unusual patterns, '
                || 'outliers, and potential operational problems.'

        ELSE
            'Apply AI to analyze, automate, optimize, or augment this '
            || 'activity based on its process context and available data.'
    END,

    -- --------------------------------------------------------
    -- AI Type
    -- --------------------------------------------------------
    CASE
        WHEN a.activity_type IN (
            'PREDICTION',
            'RISK_ANALYSIS'
        )
            THEN 'PREDICTIVE_ANALYTICS'

        WHEN a.activity_type = 'ANOMALY_DETECTION'
            THEN 'ANOMALY_DETECTION'

        WHEN a.activity_type = 'RECOMMENDATION'
            THEN 'RECOMMENDATION'

        WHEN a.activity_type = 'CLASSIFICATION'
            THEN 'CLASSIFICATION'

        WHEN a.activity_type = 'OPTIMIZATION'
            THEN 'OPTIMIZATION'

        WHEN a.activity_type = 'CREATIVE'
            THEN 'GENERATIVE_AI'

        WHEN a.activity_type = 'COMMUNICATION'
            THEN 'GENERATIVE_AI'

        WHEN a.activity_type = 'DECISION_MAKING'
            THEN 'DECISION_SUPPORT'

        WHEN a.activity_type = 'EXCEPTION_HANDLING'
            THEN 'AI_ASSISTED_INVESTIGATION'

        WHEN a.activity_type = 'PHYSICAL_OPERATION'
            THEN 'AI_AUGMENTATION'

        ELSE
            'INTELLIGENT_AUTOMATION'
    END,

    -- --------------------------------------------------------
    -- Technology
    -- --------------------------------------------------------
    CASE
        WHEN a.activity_type = 'CREATIVE'
            THEN 'Generative AI'

        WHEN a.activity_type IN (
            'COMMUNICATION',
            'DECISION_MAKING'
        )
            THEN 'LLM + Machine Learning'

        WHEN a.activity_type IN (
            'PREDICTION',
            'RISK_ANALYSIS',
            'ANOMALY_DETECTION'
        )
            THEN 'Machine Learning'

        WHEN a.activity_type = 'RECOMMENDATION'
            THEN 'Recommendation Systems'

        WHEN a.activity_type = 'CLASSIFICATION'
            THEN 'Machine Learning'

        WHEN a.activity_type = 'OPTIMIZATION'
            THEN 'Optimization + Machine Learning'

        WHEN a.activity_type = 'PHYSICAL_OPERATION'
            THEN 'Computer Vision + Robotics'

        WHEN a.activity_type = 'EXCEPTION_HANDLING'
            THEN 'AI Agent + Machine Learning'

        ELSE
            'Machine Learning + Analytics'
    END,

    -- --------------------------------------------------------
    -- Automation score
    --
    -- Based primarily on existing activity automation level.
    -- Physical activities are capped lower because AI assists
    -- rather than completely replacing the physical work.
    -- --------------------------------------------------------
    CASE
        WHEN a.activity_type = 'PHYSICAL_OPERATION'
            THEN LEAST(a.automation_level * 0.55, 70)

        WHEN a.activity_type = 'DECISION_MAKING'
            THEN LEAST(a.automation_level * 0.65, 75)

        WHEN a.activity_type = 'EXCEPTION_HANDLING'
            THEN LEAST(a.automation_level * 0.75, 80)

        ELSE
            LEAST(a.automation_level * 0.90, 95)
    END,

    -- --------------------------------------------------------
    -- Augmentation score
    --
    -- Human-heavy activities get stronger augmentation scores.
    -- Highly structured activities still receive augmentation
    -- value because humans may supervise AI outputs.
    -- --------------------------------------------------------
    CASE
        WHEN a.activity_type IN (
            'PHYSICAL_OPERATION',
            'DECISION_MAKING',
            'EXCEPTION_HANDLING'
        )
            THEN GREATEST(
                85,
                LEAST(a.automation_level + 15, 98)
            )

        WHEN a.activity_type IN (
            'CREATIVE',
            'COMMUNICATION',
            'RECOMMENDATION'
        )
            THEN GREATEST(
                88,
                LEAST(a.automation_level + 10, 98)
            )

        ELSE
            GREATEST(
                75,
                LEAST(a.automation_level + 5, 97)
            )
    END,

    -- --------------------------------------------------------
    -- Confidence score
    -- --------------------------------------------------------
    CASE
        WHEN a.activity_type IN (
            'PREDICTION',
            'CLASSIFICATION',
            'ANOMALY_DETECTION',
            'RISK_ANALYSIS',
            'OPTIMIZATION',
            'VALIDATION'
        )
            THEN 95.00

        WHEN a.activity_type IN (
            'RECOMMENDATION',
            'ANALYSIS',
            'MONITORING'
        )
            THEN 93.00

        WHEN a.activity_type IN (
            'CREATIVE',
            'COMMUNICATION'
        )
            THEN 91.00

        WHEN a.activity_type IN (
            'DECISION_MAKING',
            'EXCEPTION_HANDLING'
        )
            THEN 88.00

        WHEN a.activity_type = 'PHYSICAL_OPERATION'
            THEN 82.00

        ELSE
            90.00
    END,

    'identified'

FROM activities a

WHERE NOT EXISTS (
    SELECT 1
    FROM ai_opportunities existing
    WHERE existing.activity_id = a.activity_id
);

COMMIT;