-- ============================================================
-- NovaCart AI
-- Seed 011: Future Roles
--
-- Existing Role -> Future AI-Enabled Role
-- ============================================================

BEGIN;

-- 1. Marketing Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Marketing Strategist',
    'Leads AI-enabled marketing strategy, campaign optimization, personalization, customer segmentation, and AI-assisted decision making.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_MARKETING_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Marketing Strategist'
);


-- 2. Digital Marketing Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Digital Marketing Specialist',
    'Operates AI-enabled campaign systems, personalization engines, generative AI content workflows, and automated targeting platforms.',
    93.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_DIGITAL_MARKETING_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Digital Marketing Specialist'
);


-- 3. Customer Acquisition Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Customer Intelligence Analyst',
    'Uses AI, machine learning, customer analytics, segmentation, and propensity modeling to improve acquisition and retention decisions.',
    96.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_CUSTOMER_ACQUISITION_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Customer Intelligence Analyst'
);


-- 4. Merchandising Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Merchandising Strategist',
    'Uses AI demand intelligence, assortment optimization, customer behavior, and product recommendations to improve merchandising decisions.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_MERCHANDISING_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Merchandising Strategist'
);


-- 5. Catalog Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Catalog Intelligence Specialist',
    'Supervises AI-assisted product classification, catalog quality, duplicate detection, content generation, and product enrichment.',
    92.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_CATALOG_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Catalog Intelligence Specialist'
);


-- 6. Pricing Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Pricing Intelligence Analyst',
    'Uses AI forecasting, competitive intelligence, demand signals, and optimization models to support pricing decisions.',
    95.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_PRICING_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Pricing Intelligence Analyst'
);


-- 7. Product Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Product Manager',
    'Leads AI-enabled product strategy, prioritization, experimentation, intelligent recommendations, and AI product governance.',
    97.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_PRODUCT_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Product Manager'
);


-- 8. Order Operations Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Order Operations Specialist',
    'Supervises AI-assisted order processing, exception detection, prioritization, and operational workflow automation.',
    93.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_ORDER_OPERATIONS_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Order Operations Specialist'
);


-- 9. Order Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Order Intelligence Analyst',
    'Uses predictive analytics and AI monitoring to identify order risks, delays, anomalies, and operational trends.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_ORDER_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Order Intelligence Analyst'
);


-- 10. Order Operations Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Operations Manager',
    'Leads AI-enabled order operations, automation governance, exception management, and operational optimization.',
    95.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_ORDER_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Operations Manager'
);


-- 11. Fulfillment Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Fulfillment Manager',
    'Leads AI-enabled fulfillment optimization, inventory coordination, picking, packing, routing, and operational exception management.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_FULFILLMENT_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Fulfillment Manager'
);


-- 12. Inventory Planner
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Inventory Intelligence Planner',
    'Uses AI demand forecasting, inventory optimization, anomaly detection, and scenario analysis to improve inventory planning.',
    96.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_INVENTORY_PLANNER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Inventory Intelligence Planner'
);


-- 13. Warehouse Associate
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI-Assisted Fulfillment Associate',
    'Works with AI-enabled warehouse systems, intelligent picking and packing workflows, computer vision, and operational assistance.',
    91.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_WAREHOUSE_ASSOCIATE'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI-Assisted Fulfillment Associate'
);


-- 14. Logistics Coordinator
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Logistics Intelligence Coordinator',
    'Coordinates AI-assisted routing, delivery monitoring, logistics exceptions, and transportation optimization.',
    93.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_LOGISTICS_COORDINATOR'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Logistics Intelligence Coordinator'
);


-- 15. Last-Mile Delivery Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Last-Mile Intelligence Analyst',
    'Uses AI prediction and optimization to analyze delivery performance, delays, routing, and last-mile operational risks.',
    95.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_LAST_MILE_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Last-Mile Intelligence Analyst'
);


-- 16. Payment Operations Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Payment Intelligence Specialist',
    'Supervises AI-enabled payment monitoring, anomaly detection, transaction analysis, and payment exception workflows.',
    95.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_PAYMENT_OPERATIONS_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Payment Intelligence Specialist'
);


-- 17. Fraud Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Fraud Risk Analyst',
    'Monitors AI fraud detection systems, investigates high-risk transactions, validates model outputs, and manages fraud exceptions.',
    98.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_FRAUD_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Fraud Risk Analyst'
);


-- 18. Fraud Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Fraud Risk Manager',
    'Leads AI-enabled fraud prevention, model oversight, risk strategy, investigation governance, and fraud operations.',
    98.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_FRAUD_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Fraud Risk Manager'
);


-- 19. Financial Reconciliation Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Financial Reconciliation Analyst',
    'Uses AI anomaly detection and intelligent matching to automate reconciliation while managing exceptions and validation.',
    96.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_FINANCIAL_RECONCILIATION_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Financial Reconciliation Analyst'
);


-- 20. Customer Support Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Customer Support Specialist',
    'Works alongside AI support agents, supervises automated responses, handles escalations, and validates customer-service outcomes.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_CUSTOMER_SUPPORT_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Customer Support Specialist'
);


-- 21. Customer Experience Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Customer Experience Analyst',
    'Uses AI sentiment, behavioral analytics, personalization, and journey intelligence to improve customer experience.',
    95.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_CUSTOMER_EXPERIENCE_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Customer Experience Analyst'
);


-- 22. Customer Service Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Customer Service Manager',
    'Leads AI-enabled customer service operations, agent supervision, escalation management, and service quality governance.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_CUSTOMER_SERVICE_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Customer Service Manager'
);


-- 23. Returns Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Returns Intelligence Specialist',
    'Uses AI classification, prediction, anomaly detection, and decision support to improve returns processing and exception management.',
    94.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_RETURNS_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Returns Intelligence Specialist'
);


-- 24. Refund Operations Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Refund Operations Specialist',
    'Supervises AI-assisted refund validation, anomaly detection, customer communication, and exception workflows.',
    93.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_REFUNDS_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Refund Operations Specialist'
);


-- 25. Customer Retention Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Customer Retention Strategist',
    'Uses AI churn prediction, customer intelligence, personalization, and recommendation systems to improve retention.',
    97.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_CUSTOMER_RETENTION_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Customer Retention Strategist'
);


-- 26. Data Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI-Augmented Data Analyst',
    'Combines analytics expertise with AI-assisted analysis, automated insight generation, data quality monitoring, and model output validation.',
    97.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_DATA_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI-Augmented Data Analyst'
);


-- 27. Business Analyst
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Business Intelligence Analyst',
    'Uses AI-assisted analysis, decision support, process intelligence, and scenario modeling to support enterprise decisions.',
    96.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_BUSINESS_ANALYST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Business Intelligence Analyst'
);


-- 28. AI Automation Specialist
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Automation Architect',
    'Designs, deploys, monitors, and governs intelligent automation and AI-enabled enterprise workflows.',
    99.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_AI_AUTOMATION_SPECIALIST'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Automation Architect'
);


-- 29. AI Product Manager
INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    role_id,
    'AI Product Strategy Manager',
    'Leads AI product strategy, AI capability prioritization, experimentation, governance, and business value realization.',
    99.00,
    'NovaCart AI Intelligence Model'
FROM roles
WHERE role_code = 'ROLE_AI_PRODUCT_MANAGER'
AND NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Product Strategy Manager'
);


-- ============================================================
-- Additional cross-functional future roles
-- ============================================================

INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    NULL,
    'AI Governance & Model Risk Specialist',
    'Provides governance, validation, monitoring, risk assessment, and responsible-use oversight for enterprise AI and machine learning systems.',
    98.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Governance & Model Risk Specialist'
);


INSERT INTO future_roles (
    role_id, name, description, emergence_score, source
)
SELECT
    NULL,
    'AI Agent Operations Specialist',
    'Supervises AI agents operating across enterprise workflows, manages exceptions, evaluates agent performance, and coordinates human intervention.',
    96.00,
    'NovaCart AI Intelligence Model'
WHERE NOT EXISTS (
    SELECT 1 FROM future_roles
    WHERE name = 'AI Agent Operations Specialist'
);


COMMIT;