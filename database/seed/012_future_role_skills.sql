-- ============================================================
-- NovaCart AI
-- Seed 012: Future Role -> Future Skills
-- ============================================================

BEGIN;

-- ============================================================
-- MARKETING / CUSTOMER INTELLIGENCE
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Business Strategy', 98.00),
    ('AI-Augmented Market Analysis', 95.00),
    ('AI-Augmented Customer Analysis', 96.00),
    ('AI-Augmented Decision Making', 96.00),
    ('Generative AI Application', 91.00),
    ('AI-Assisted Decision Making', 95.00),
    ('AI Output Validation', 88.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Marketing Strategist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Data Analysis', 98.00),
    ('AI-Augmented Customer Analysis', 99.00),
    ('AI-Augmented Market Analysis', 92.00),
    ('Machine Learning Model Oversight', 94.00),
    ('AI-Augmented Decision Making', 94.00),
    ('AI Output Validation', 96.00),
    ('AI Data Quality Management', 95.00),
    ('AI-Assisted Decision Making', 92.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Customer Intelligence Analyst';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('Generative AI Application', 98.00),
    ('AI Prompt Engineering', 94.00),
    ('AI-Augmented Customer Analysis', 92.00),
    ('AI-Augmented Market Analysis', 90.00),
    ('AI-Assisted Customer Experience', 96.00),
    ('AI Output Validation', 94.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Digital Marketing Specialist';


-- ============================================================
-- MERCHANDISING / CATALOG / PRICING
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Business Strategy', 94.00),
    ('AI-Augmented Data Analysis', 95.00),
    ('AI-Augmented Market Analysis', 94.00),
    ('AI-Augmented Customer Analysis', 92.00),
    ('AI-Augmented Decision Making', 96.00),
    ('AI-Assisted Decision Making', 95.00),
    ('AI Output Validation', 89.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Merchandising Strategist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('Generative AI Application', 95.00),
    ('AI Data Quality Management', 98.00),
    ('AI Output Validation', 97.00),
    ('AI-Augmented Data Analysis', 91.00),
    ('AI-Assisted Operations', 88.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Catalog Intelligence Specialist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Pricing Analysis', 99.00),
    ('AI-Augmented Data Analysis', 96.00),
    ('AI-Augmented Market Analysis', 95.00),
    ('Machine Learning Model Oversight', 93.00),
    ('AI-Assisted Decision Making', 96.00),
    ('AI Output Validation', 94.00),
    ('AI Data Quality Management', 90.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Pricing Intelligence Analyst';


-- ============================================================
-- PRODUCT
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Business Strategy', 98.00),
    ('AI-Augmented Customer Analysis', 96.00),
    ('AI-Augmented Market Analysis', 95.00),
    ('AI-Augmented Data Analysis', 94.00),
    ('AI-Augmented Decision Making', 98.00),
    ('AI-Assisted Decision Making', 97.00),
    ('Generative AI Application', 88.00),
    ('AI Governance', 90.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Product Manager';


-- ============================================================
-- ORDER / OPERATIONS
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Operations', 98.00),
    ('AI-Augmented Data Analysis', 94.00),
    ('AI-Assisted Decision Making', 96.00),
    ('AI Agent Supervision', 92.00),
    ('AI Output Validation', 94.00),
    ('AI Data Quality Management', 90.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Order Operations Specialist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Data Analysis', 98.00),
    ('AI-Augmented Decision Making', 96.00),
    ('AI-Assisted Decision Making', 95.00),
    ('AI Output Validation', 93.00),
    ('AI Data Quality Management', 91.00),
    ('AI-Assisted Operations', 90.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Order Intelligence Analyst';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Operations', 99.00),
    ('AI-Augmented Business Strategy', 95.00),
    ('AI-Assisted Decision Making', 98.00),
    ('AI Agent Supervision', 96.00),
    ('AI Output Validation', 94.00),
    ('AI Governance', 88.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Operations Manager';


-- ============================================================
-- FULFILLMENT / INVENTORY / LOGISTICS
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Fulfillment', 99.00),
    ('AI-Assisted Operations', 96.00),
    ('AI-Agent Supervision', 91.00),
    ('AI-Assisted Decision Making', 94.00),
    ('AI Output Validation', 89.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Fulfillment Manager';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Data Analysis', 97.00),
    ('AI-Assisted Decision Making', 96.00),
    ('AI-Assisted Operations', 91.00),
    ('AI Data Quality Management', 93.00),
    ('AI Output Validation', 90.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Inventory Intelligence Planner';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Fulfillment', 99.00),
    ('AI-Assisted Operations', 94.00),
    ('AI Agent Supervision', 90.00),
    ('AI Output Validation', 86.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI-Assisted Fulfillment Associate';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Operations', 97.00),
    ('AI-Assisted Decision Making', 95.00),
    ('AI-Augmented Data Analysis', 93.00),
    ('AI Agent Supervision', 91.00),
    ('AI Output Validation', 89.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Logistics Intelligence Coordinator';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Data Analysis', 97.00),
    ('AI-Assisted Decision Making', 96.00),
    ('AI-Assisted Operations', 94.00),
    ('AI Output Validation', 91.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Last-Mile Intelligence Analyst';


-- ============================================================
-- PAYMENT / FRAUD / FINANCE
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Data Analysis', 96.00),
    ('AI Output Validation', 97.00),
    ('AI Data Quality Management', 95.00),
    ('AI-Assisted Decision Making', 94.00),
    ('AI-Assisted Operations', 91.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Payment Intelligence Specialist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Risk Analysis', 99.00),
    ('AI-Augmented Fraud Detection', 99.00),
    ('Machine Learning Model Oversight', 98.00),
    ('Model Risk Management', 99.00),
    ('AI Output Validation', 98.00),
    ('AI Governance', 96.00),
    ('AI-Augmented Data Analysis', 94.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Fraud Risk Analyst';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Risk Analysis', 99.00),
    ('AI-Augmented Fraud Detection', 99.00),
    ('Model Risk Management', 100.00),
    ('Machine Learning Model Oversight', 99.00),
    ('AI Governance', 98.00),
    ('AI-Assisted Decision Making', 96.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Fraud Risk Manager';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Data Analysis', 98.00),
    ('AI Data Quality Management', 98.00),
    ('AI Output Validation', 96.00),
    ('AI-Assisted Operations', 94.00),
    ('AI-Assisted Decision Making', 91.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Financial Reconciliation Analyst';


-- ============================================================
-- CUSTOMER EXPERIENCE
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Customer Experience', 99.00),
    ('AI-Augmented Customer Analysis', 96.00),
    ('Generative AI Application', 93.00),
    ('AI Prompt Engineering', 88.00),
    ('AI Output Validation', 95.00),
    ('AI-Assisted Decision Making', 92.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Customer Support Specialist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Customer Experience', 99.00),
    ('AI-Augmented Customer Analysis', 98.00),
    ('AI-Augmented Data Analysis', 94.00),
    ('AI-Assisted Decision Making', 94.00),
    ('AI Output Validation', 92.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Customer Experience Analyst';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Customer Experience', 99.00),
    ('AI Agent Supervision', 97.00),
    ('AI Output Validation', 96.00),
    ('AI-Assisted Decision Making', 95.00),
    ('AI Governance', 88.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Customer Service Manager';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Customer Experience', 98.00),
    ('AI-Augmented Customer Analysis', 96.00),
    ('AI-Augmented Data Analysis', 91.00),
    ('AI-Assisted Decision Making', 90.00),
    ('AI Output Validation', 91.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Customer Retention Strategist';


-- ============================================================
-- RETURNS / REFUNDS
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Operations', 96.00),
    ('AI-Augmented Data Analysis', 92.00),
    ('AI-Assisted Decision Making', 94.00),
    ('AI Output Validation', 95.00),
    ('AI Data Quality Management', 91.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Returns Intelligence Specialist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Assisted Operations', 96.00),
    ('AI-Augmented Data Analysis', 93.00),
    ('AI Output Validation', 97.00),
    ('AI-Assisted Decision Making', 92.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Refund Operations Specialist';


-- ============================================================
-- DATA / BUSINESS / AI
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Data Analysis', 100.00),
    ('AI Data Quality Management', 98.00),
    ('AI Output Validation', 98.00),
    ('Machine Learning Model Oversight', 94.00),
    ('AI-Assisted Decision Making', 95.00),
    ('AI Prompt Engineering', 86.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI-Augmented Data Analyst';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Business Strategy', 97.00),
    ('AI-Augmented Data Analysis', 96.00),
    ('AI-Augmented Decision Making', 98.00),
    ('AI-Assisted Decision Making', 98.00),
    ('AI Output Validation', 91.00),
    ('AI Data Quality Management', 89.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Business Intelligence Analyst';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI Agent Supervision', 99.00),
    ('AI-Assisted Operations', 98.00),
    ('AI Prompt Engineering', 93.00),
    ('AI Output Validation', 97.00),
    ('AI Governance', 95.00),
    ('AI Data Quality Management', 94.00),
    ('AI-Assisted Decision Making', 96.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Automation Architect';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI-Augmented Business Strategy', 99.00),
    ('AI-Assisted Decision Making', 99.00),
    ('AI Governance', 96.00),
    ('AI Output Validation', 95.00),
    ('AI-Augmented Data Analysis', 93.00),
    ('Generative AI Application', 91.00),
    ('AI Agent Supervision', 90.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Product Strategy Manager';


-- ============================================================
-- CROSS-FUNCTIONAL EMERGING ROLES
-- ============================================================

INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI Governance', 100.00),
    ('Model Risk Management', 100.00),
    ('Machine Learning Model Oversight', 99.00),
    ('AI Output Validation', 98.00),
    ('AI Data Quality Management', 96.00),
    ('AI-Augmented Risk Analysis', 94.00),
    ('AI-Assisted Decision Making', 92.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Governance & Model Risk Specialist';


INSERT INTO future_role_skills (future_role_id, future_skill_id, importance)
SELECT fr.future_role_id, fs.future_skill_id, x.importance
FROM future_roles fr
CROSS JOIN future_skills fs
JOIN (
    VALUES
    ('AI Agent Supervision', 100.00),
    ('AI-Assisted Operations', 98.00),
    ('AI-Assisted Decision Making', 96.00),
    ('AI Output Validation', 97.00),
    ('AI Governance', 94.00),
    ('AI Data Quality Management', 92.00),
    ('AI Prompt Engineering', 90.00)
) x(skill_name, importance)
ON fs.name = x.skill_name
WHERE fr.name = 'AI Agent Operations Specialist';


COMMIT;