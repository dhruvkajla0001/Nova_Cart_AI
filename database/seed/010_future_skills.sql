-- ============================================================
-- NovaCart AI
-- Seed 010: Future Skills
--
-- Current Skills -> Future Skills
-- Emerging AI capabilities
-- ============================================================

BEGIN;

-- ============================================================
-- 1. AI-AUGMENTED EXISTING SKILLS
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    s.skill_id,
    'AI-Augmented ' || s.name,
    'Ability to apply AI systems to ' || LOWER(s.name)
    || ', interpret AI-generated outputs, validate results, '
    || 'and incorporate AI into enterprise workflows.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM skills s
WHERE s.name IN (
    'Data Analysis',
    'Market Analysis',
    'Customer Analysis',
    'Business Strategy',
    'Decision Making',
    'Risk Analysis',
    'Fraud Detection',
    'Demand Forecasting',
    'Pricing Analysis'
)
AND NOT EXISTS (
    SELECT 1
    FROM future_skills fs
    WHERE fs.name = 'AI-Augmented ' || s.name
);


-- ============================================================
-- 2. MACHINE LEARNING MODEL OVERSIGHT
-- One future-skill node only
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'Machine Learning Model Oversight',
    'Ability to evaluate, monitor, validate, and govern machine learning models used in business decision-making.',
    97.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'Machine Learning Model Oversight'
);


-- ============================================================
-- 3. GENERATIVE AI APPLICATION
-- One future-skill node only
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'Generative AI Application',
    'Ability to use generative AI to create, transform, summarize, and evaluate business content while maintaining quality and governance.',
    96.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'Generative AI Application'
);


-- ============================================================
-- 4. AI PROMPT ENGINEERING
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI Prompt Engineering',
    'Ability to design effective instructions for generative AI systems, evaluate outputs, and adapt prompts to enterprise workflows.',
    92.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI Prompt Engineering'
);


-- ============================================================
-- 5. AI OUTPUT VALIDATION
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI Output Validation',
    'Ability to evaluate AI-generated recommendations, predictions, classifications, and content for accuracy, quality, and business suitability.',
    96.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI Output Validation'
);


-- ============================================================
-- 6. AI GOVERNANCE
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI Governance',
    'Ability to apply governance, accountability, transparency, and responsible-use principles to enterprise AI systems.',
    95.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI Governance'
);


-- ============================================================
-- 7. MODEL RISK MANAGEMENT
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'Model Risk Management',
    'Ability to monitor AI and machine learning model risk, validate model behavior, identify limitations, and support governance.',
    98.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'Model Risk Management'
);


-- ============================================================
-- 8. AI-ASSISTED DECISION MAKING
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI-Assisted Decision Making',
    'Ability to combine human judgment with AI recommendations, predictions, and scenario analysis for enterprise decisions.',
    97.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI-Assisted Decision Making'
);


-- ============================================================
-- 9. AI AGENT SUPERVISION
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI Agent Supervision',
    'Ability to supervise AI agents, review their actions, manage exceptions, and intervene when human judgment is required.',
    94.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI Agent Supervision'
);


-- ============================================================
-- 10. AI DATA QUALITY MANAGEMENT
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI Data Quality Management',
    'Ability to identify, validate, and improve data quality used by AI and machine learning systems.',
    95.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI Data Quality Management'
);


-- ============================================================
-- 11. AI-ASSISTED CUSTOMER EXPERIENCE
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI-Assisted Customer Experience',
    'Ability to combine AI personalization, recommendation, sentiment analysis, and human interaction to improve customer experience.',
    93.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI-Assisted Customer Experience'
);


-- ============================================================
-- 12. AI-ASSISTED OPERATIONS
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI-Assisted Operations',
    'Ability to work with AI-enabled operational systems, interpret recommendations, manage exceptions, and optimize workflows.',
    92.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI-Assisted Operations'
);


-- ============================================================
-- 13. AI-ASSISTED FULFILLMENT
-- ============================================================

INSERT INTO future_skills (
    skill_id,
    name,
    description,
    demand_score,
    source
)
SELECT
    NULL,
    'AI-Assisted Fulfillment',
    'Ability to operate and supervise AI-enabled fulfillment systems, intelligent picking, packing, routing, and exception workflows.',
    91.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1
    FROM future_skills
    WHERE name = 'AI-Assisted Fulfillment'
);


COMMIT;