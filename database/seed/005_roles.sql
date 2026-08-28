-- ============================================================
-- NovaCart AI
-- Seed 005: Roles
-- ============================================================

BEGIN;

INSERT INTO roles (
    role_code,
    name,
    description,
    seniority_level
)
VALUES

-- Customer Acquisition
(
    'ROLE_MARKETING_MANAGER',
    'Marketing Manager',
    'Owns customer acquisition strategy, campaign planning, marketing performance, and budget allocation.',
    'MANAGER'
),

(
    'ROLE_DIGITAL_MARKETING_SPECIALIST',
    'Digital Marketing Specialist',
    'Executes digital campaigns, manages targeting, monitors performance, and optimizes acquisition channels.',
    'SPECIALIST'
),

(
    'ROLE_CUSTOMER_ACQUISITION_ANALYST',
    'Customer Acquisition Analyst',
    'Analyzes customer segments, acquisition funnels, conversion behavior, and campaign performance.',
    'ANALYST'
),

-- Merchandising & Catalog
(
    'ROLE_MERCHANDISING_MANAGER',
    'Merchandising Manager',
    'Owns product assortment, merchandising strategy, demand analysis, and commercial decisions.',
    'MANAGER'
),

(
    'ROLE_CATALOG_SPECIALIST',
    'Catalog Specialist',
    'Maintains product information, categories, listings, attributes, and catalog quality.',
    'SPECIALIST'
),

(
    'ROLE_PRICING_ANALYST',
    'Pricing Analyst',
    'Analyzes market conditions, competitor prices, demand, margins, and pricing opportunities.',
    'ANALYST'
),

(
    'ROLE_PRODUCT_MANAGER',
    'Product Manager',
    'Owns product strategy, assortment decisions, customer experience, and product performance.',
    'MANAGER'
),

-- Order Management
(
    'ROLE_ORDER_OPERATIONS_SPECIALIST',
    'Order Operations Specialist',
    'Manages order validation, processing, tracking, and operational exceptions.',
    'SPECIALIST'
),

(
    'ROLE_ORDER_ANALYST',
    'Order Analyst',
    'Analyzes order patterns, exceptions, delays, and operational performance.',
    'ANALYST'
),

(
    'ROLE_ORDER_MANAGER',
    'Order Operations Manager',
    'Owns order management performance, operational policies, and exception resolution.',
    'MANAGER'
),

-- Fulfillment & Delivery
(
    'ROLE_FULFILLMENT_MANAGER',
    'Fulfillment Manager',
    'Owns warehouse fulfillment performance, inventory allocation, and operational efficiency.',
    'MANAGER'
),

(
    'ROLE_INVENTORY_PLANNER',
    'Inventory Planner',
    'Plans inventory allocation and monitors inventory availability against demand.',
    'SPECIALIST'
),

(
    'ROLE_WAREHOUSE_ASSOCIATE',
    'Warehouse Operations Associate',
    'Performs physical warehouse activities including picking, verification, and packing.',
    'OPERATOR'
),

(
    'ROLE_LOGISTICS_COORDINATOR',
    'Logistics Coordinator',
    'Coordinates shipments, carriers, delivery status, and logistics exceptions.',
    'SPECIALIST'
),

(
    'ROLE_LAST_MILE_ANALYST',
    'Last-Mile Delivery Analyst',
    'Monitors delivery performance and analyzes delays and delivery exceptions.',
    'ANALYST'
),

-- Payments & Fraud
(
    'ROLE_PAYMENT_OPERATIONS_SPECIALIST',
    'Payment Operations Specialist',
    'Manages payment processing, transaction issues, and payment operations.',
    'SPECIALIST'
),

(
    'ROLE_FRAUD_ANALYST',
    'Fraud Analyst',
    'Investigates suspicious transactions and evaluates fraud risk.',
    'ANALYST'
),

(
    'ROLE_FRAUD_MANAGER',
    'Fraud Manager',
    'Owns fraud prevention strategy, risk policies, and fraud operations.',
    'MANAGER'
),

(
    'ROLE_FINANCIAL_RECONCILIATION_ANALYST',
    'Financial Reconciliation Analyst',
    'Reconciles payment transactions, orders, refunds, and financial records.',
    'ANALYST'
),

-- Customer Service
(
    'ROLE_CUSTOMER_SUPPORT_SPECIALIST',
    'Customer Support Specialist',
    'Handles customer inquiries, service requests, and customer issues.',
    'SPECIALIST'
),

(
    'ROLE_CUSTOMER_EXPERIENCE_ANALYST',
    'Customer Experience Analyst',
    'Analyzes customer feedback, sentiment, service trends, and recurring issues.',
    'ANALYST'
),

(
    'ROLE_CUSTOMER_SERVICE_MANAGER',
    'Customer Service Manager',
    'Owns customer service performance, policies, quality, and operational improvement.',
    'MANAGER'
),

-- Post-Purchase & Returns
(
    'ROLE_RETURNS_SPECIALIST',
    'Returns Specialist',
    'Manages return requests, eligibility checks, exchanges, and return exceptions.',
    'SPECIALIST'
),

(
    'ROLE_REFUNDS_SPECIALIST',
    'Refund Operations Specialist',
    'Manages refund validation, processing, and reconciliation.',
    'SPECIALIST'
),

(
    'ROLE_CUSTOMER_RETENTION_MANAGER',
    'Customer Retention Manager',
    'Owns retention strategy, churn prevention, and customer lifecycle initiatives.',
    'MANAGER'
),

-- Cross-functional / Intelligence
(
    'ROLE_DATA_ANALYST',
    'Data Analyst',
    'Analyzes operational and customer data to identify patterns, opportunities, and business insights.',
    'ANALYST'
),

(
    'ROLE_BUSINESS_ANALYST',
    'Business Analyst',
    'Analyzes business processes, requirements, operational performance, and improvement opportunities.',
    'ANALYST'
),

(
    'ROLE_AI_AUTOMATION_SPECIALIST',
    'AI Automation Specialist',
    'Identifies, evaluates, and implements AI-based automation and augmentation opportunities.',
    'SPECIALIST'
),

(
    'ROLE_AI_PRODUCT_MANAGER',
    'AI Product Manager',
    'Leads AI-enabled product capabilities, business outcomes, and AI transformation initiatives.',
    'MANAGER'
)

ON CONFLICT (role_code) DO NOTHING;

COMMIT;