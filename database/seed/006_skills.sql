-- ============================================================
-- NovaCart AI
-- Seed 006: Skills
-- ============================================================

BEGIN;

INSERT INTO skills (
    skill_code,
    name,
    description,
    category,
    skill_type
)
VALUES

-- ============================================================
-- BUSINESS & STRATEGY
-- ============================================================

(
    'SKILL_BUSINESS_STRATEGY',
    'Business Strategy',
    'Ability to define business direction, priorities, and strategic initiatives.',
    'BUSINESS',
    'STRATEGIC'
),

(
    'SKILL_MARKET_ANALYSIS',
    'Market Analysis',
    'Ability to analyze market conditions, competitors, trends, and customer demand.',
    'BUSINESS',
    'ANALYTICAL'
),

(
    'SKILL_CUSTOMER_ANALYSIS',
    'Customer Analysis',
    'Ability to analyze customer behavior, segments, preferences, and lifecycle patterns.',
    'BUSINESS',
    'ANALYTICAL'
),

(
    'SKILL_PROCESS_ANALYSIS',
    'Process Analysis',
    'Ability to analyze business processes and identify operational improvement opportunities.',
    'BUSINESS',
    'ANALYTICAL'
),

(
    'SKILL_DECISION_MAKING',
    'Decision Making',
    'Ability to evaluate information and make effective operational or business decisions.',
    'BUSINESS',
    'COGNITIVE'
),

(
    'SKILL_STAKEHOLDER_MANAGEMENT',
    'Stakeholder Management',
    'Ability to communicate with and coordinate multiple business stakeholders.',
    'BUSINESS',
    'INTERPERSONAL'
),

-- ============================================================
-- MARKETING
-- ============================================================

(
    'SKILL_DIGITAL_MARKETING',
    'Digital Marketing',
    'Ability to design, execute, and optimize digital marketing campaigns.',
    'MARKETING',
    'FUNCTIONAL'
),

(
    'SKILL_CAMPAIGN_MANAGEMENT',
    'Campaign Management',
    'Ability to plan, launch, monitor, and optimize marketing campaigns.',
    'MARKETING',
    'FUNCTIONAL'
),

(
    'SKILL_MARKETING_ANALYTICS',
    'Marketing Analytics',
    'Ability to analyze campaign performance, acquisition metrics, and conversion funnels.',
    'MARKETING',
    'ANALYTICAL'
),

(
    'SKILL_CONTENT_CREATION',
    'Content Creation',
    'Ability to develop marketing content, product messaging, and promotional assets.',
    'MARKETING',
    'CREATIVE'
),

(
    'SKILL_CUSTOMER_SEGMENTATION',
    'Customer Segmentation',
    'Ability to identify and analyze meaningful customer segments.',
    'MARKETING',
    'ANALYTICAL'
),

-- ============================================================
-- MERCHANDISING & PRODUCT
-- ============================================================

(
    'SKILL_PRODUCT_MANAGEMENT',
    'Product Management',
    'Ability to manage product strategy, prioritization, and product lifecycle decisions.',
    'PRODUCT',
    'FUNCTIONAL'
),

(
    'SKILL_MERCHANDISING',
    'Merchandising',
    'Ability to manage product assortment, placement, and commercial performance.',
    'PRODUCT',
    'FUNCTIONAL'
),

(
    'SKILL_CATALOG_MANAGEMENT',
    'Catalog Management',
    'Ability to maintain structured and accurate product catalog information.',
    'PRODUCT',
    'FUNCTIONAL'
),

(
    'SKILL_PRODUCT_DATA_QUALITY',
    'Product Data Quality',
    'Ability to validate and improve product information quality and completeness.',
    'PRODUCT',
    'TECHNICAL'
),

(
    'SKILL_PRICING_ANALYSIS',
    'Pricing Analysis',
    'Ability to analyze prices, margins, demand, and competitive pricing.',
    'PRODUCT',
    'ANALYTICAL'
),

(
    'SKILL_DEMAND_ANALYSIS',
    'Demand Analysis',
    'Ability to analyze historical and current demand patterns.',
    'PRODUCT',
    'ANALYTICAL'
),

-- ============================================================
-- ORDER OPERATIONS
-- ============================================================

(
    'SKILL_ORDER_MANAGEMENT',
    'Order Management',
    'Ability to manage order capture, validation, processing, and tracking.',
    'OPERATIONS',
    'FUNCTIONAL'
),

(
    'SKILL_ORDER_ANALYTICS',
    'Order Analytics',
    'Ability to analyze order patterns, exceptions, and operational performance.',
    'OPERATIONS',
    'ANALYTICAL'
),

(
    'SKILL_EXCEPTION_HANDLING',
    'Exception Handling',
    'Ability to investigate and resolve non-standard operational situations.',
    'OPERATIONS',
    'PROBLEM_SOLVING'
),

(
    'SKILL_OPERATIONAL_PLANNING',
    'Operational Planning',
    'Ability to plan and coordinate operational activities and resources.',
    'OPERATIONS',
    'FUNCTIONAL'
),

-- ============================================================
-- SUPPLY CHAIN & LOGISTICS
-- ============================================================

(
    'SKILL_INVENTORY_MANAGEMENT',
    'Inventory Management',
    'Ability to monitor, allocate, and optimize inventory.',
    'SUPPLY_CHAIN',
    'FUNCTIONAL'
),

(
    'SKILL_INVENTORY_PLANNING',
    'Inventory Planning',
    'Ability to forecast inventory requirements and plan inventory allocation.',
    'SUPPLY_CHAIN',
    'ANALYTICAL'
),

(
    'SKILL_WAREHOUSE_OPERATIONS',
    'Warehouse Operations',
    'Ability to execute and manage warehouse fulfillment operations.',
    'SUPPLY_CHAIN',
    'FUNCTIONAL'
),

(
    'SKILL_LOGISTICS_MANAGEMENT',
    'Logistics Management',
    'Ability to coordinate transportation, carriers, shipments, and delivery operations.',
    'SUPPLY_CHAIN',
    'FUNCTIONAL'
),

(
    'SKILL_ROUTE_OPTIMIZATION',
    'Route Optimization',
    'Ability to optimize delivery routes and logistics decisions.',
    'SUPPLY_CHAIN',
    'ANALYTICAL'
),

(
    'SKILL_SUPPLY_CHAIN_ANALYTICS',
    'Supply Chain Analytics',
    'Ability to analyze supply chain performance, demand, inventory, and logistics data.',
    'SUPPLY_CHAIN',
    'ANALYTICAL'
),

-- ============================================================
-- PAYMENTS & FRAUD
-- ============================================================

(
    'SKILL_PAYMENT_OPERATIONS',
    'Payment Operations',
    'Ability to manage payment processing, transaction issues, and payment workflows.',
    'FINANCE',
    'FUNCTIONAL'
),

(
    'SKILL_FINANCIAL_RECONCILIATION',
    'Financial Reconciliation',
    'Ability to reconcile transactions and identify financial discrepancies.',
    'FINANCE',
    'ANALYTICAL'
),

(
    'SKILL_FRAUD_ANALYSIS',
    'Fraud Analysis',
    'Ability to investigate suspicious transactions and identify fraud patterns.',
    'RISK',
    'ANALYTICAL'
),

(
    'SKILL_RISK_ASSESSMENT',
    'Risk Assessment',
    'Ability to evaluate transaction and operational risk.',
    'RISK',
    'ANALYTICAL'
),

(
    'SKILL_TRANSACTION_MONITORING',
    'Transaction Monitoring',
    'Ability to monitor transactions and identify unusual patterns.',
    'RISK',
    'ANALYTICAL'
),

-- ============================================================
-- CUSTOMER SERVICE
-- ============================================================

(
    'SKILL_CUSTOMER_SERVICE',
    'Customer Service',
    'Ability to support customers and resolve service requests effectively.',
    'CUSTOMER',
    'FUNCTIONAL'
),

(
    'SKILL_CUSTOMER_COMMUNICATION',
    'Customer Communication',
    'Ability to communicate clearly and effectively with customers.',
    'CUSTOMER',
    'INTERPERSONAL'
),

(
    'SKILL_ISSUE_RESOLUTION',
    'Issue Resolution',
    'Ability to investigate and resolve customer problems.',
    'CUSTOMER',
    'PROBLEM_SOLVING'
),

(
    'SKILL_CUSTOMER_EXPERIENCE',
    'Customer Experience',
    'Ability to improve customer journeys, interactions, and satisfaction.',
    'CUSTOMER',
    'FUNCTIONAL'
),

(
    'SKILL_SENTIMENT_ANALYSIS',
    'Sentiment Analysis',
    'Ability to analyze customer sentiment and feedback.',
    'CUSTOMER',
    'ANALYTICAL'
),

-- ============================================================
-- RETURNS & RETENTION
-- ============================================================

(
    'SKILL_RETURNS_MANAGEMENT',
    'Returns Management',
    'Ability to manage product returns, eligibility, exchanges, and exceptions.',
    'OPERATIONS',
    'FUNCTIONAL'
),

(
    'SKILL_REFUND_PROCESSING',
    'Refund Processing',
    'Ability to manage refund validation, processing, and reconciliation.',
    'FINANCE',
    'FUNCTIONAL'
),

(
    'SKILL_CUSTOMER_RETENTION',
    'Customer Retention',
    'Ability to identify churn risks and develop retention strategies.',
    'CUSTOMER',
    'STRATEGIC'
),

(
    'SKILL_CHURN_ANALYSIS',
    'Churn Analysis',
    'Ability to identify and analyze customer churn patterns and risk factors.',
    'CUSTOMER',
    'ANALYTICAL'
),

-- ============================================================
-- DATA & ANALYTICS
-- ============================================================

(
    'SKILL_SQL',
    'SQL',
    'Ability to query, transform, analyze, and validate structured data.',
    'DATA',
    'TECHNICAL'
),

(
    'SKILL_PYTHON',
    'Python',
    'Ability to use Python for data analysis, automation, and application development.',
    'DATA',
    'TECHNICAL'
),

(
    'SKILL_DATA_ANALYSIS',
    'Data Analysis',
    'Ability to analyze datasets and convert data into actionable insights.',
    'DATA',
    'ANALYTICAL'
),

(
    'SKILL_DATA_VISUALIZATION',
    'Data Visualization',
    'Ability to communicate insights through effective visualizations and dashboards.',
    'DATA',
    'TECHNICAL'
),

(
    'SKILL_STATISTICS',
    'Statistics',
    'Ability to apply statistical methods to analyze patterns and uncertainty.',
    'DATA',
    'TECHNICAL'
),

(
    'SKILL_MACHINE_LEARNING',
    'Machine Learning',
    'Ability to develop and evaluate machine learning models for prediction and classification.',
    'AI',
    'TECHNICAL'
),

-- ============================================================
-- AI & AUTOMATION
-- ============================================================

(
    'SKILL_AI_LITERACY',
    'AI Literacy',
    'Understanding of AI capabilities, limitations, risks, and business applications.',
    'AI',
    'EMERGING'
),

(
    'SKILL_AI_WORKFLOW_DESIGN',
    'AI Workflow Design',
    'Ability to redesign business workflows around AI-enabled automation and augmentation.',
    'AI',
    'EMERGING'
),

(
    'SKILL_PROMPT_ENGINEERING',
    'Prompt Engineering',
    'Ability to design effective prompts for generative AI systems.',
    'AI',
    'TECHNICAL'
),

(
    'SKILL_RAG',
    'Retrieval-Augmented Generation',
    'Ability to build systems that combine retrieval with generative AI.',
    'AI',
    'TECHNICAL'
),

(
    'SKILL_AI_EVALUATION',
    'AI Evaluation',
    'Ability to evaluate AI systems for quality, accuracy, reliability, and business usefulness.',
    'AI',
    'TECHNICAL'
),

(
    'SKILL_AUTOMATION_DESIGN',
    'Automation Design',
    'Ability to identify and design automated workflows.',
    'AI',
    'TECHNICAL'
),

(
    'SKILL_DATA_ENGINEERING',
    'Data Engineering',
    'Ability to build reliable data pipelines and data processing systems.',
    'DATA',
    'TECHNICAL'
),

(
    'SKILL_DATA_MODELING',
    'Data Modeling',
    'Ability to design structured data models and relationships for analytical and operational systems.',
    'DATA',
    'TECHNICAL'
),

-- ============================================================
-- GOVERNANCE & RESPONSIBLE AI
-- ============================================================

(
    'SKILL_AI_GOVERNANCE',
    'AI Governance',
    'Ability to establish policies and controls for responsible AI deployment.',
    'GOVERNANCE',
    'EMERGING'
),

(
    'SKILL_MODEL_RISK',
    'Model Risk Management',
    'Ability to identify, evaluate, and manage risks associated with AI models.',
    'GOVERNANCE',
    'EMERGING'
),

(
    'SKILL_DATA_PRIVACY',
    'Data Privacy',
    'Understanding of privacy principles and responsible handling of customer data.',
    'GOVERNANCE',
    'FUNCTIONAL'
),

(
    'SKILL_AI_ETHICS',
    'AI Ethics',
    'Ability to identify and address ethical considerations in AI systems.',
    'GOVERNANCE',
    'EMERGING'
),

-- ============================================================
-- LEADERSHIP & TRANSFORMATION
-- ============================================================

(
    'SKILL_CHANGE_MANAGEMENT',
    'Change Management',
    'Ability to guide teams and organizations through technology-driven change.',
    'LEADERSHIP',
    'STRATEGIC'
),

(
    'SKILL_AI_TRANSFORMATION',
    'AI Transformation',
    'Ability to lead organizational transformation through AI adoption.',
    'LEADERSHIP',
    'STRATEGIC'
),

(
    'SKILL_CROSS_FUNCTIONAL_COLLABORATION',
    'Cross-Functional Collaboration',
    'Ability to collaborate across business, technology, operations, and analytics teams.',
    'LEADERSHIP',
    'INTERPERSONAL'
)

ON CONFLICT (skill_code) DO NOTHING;

COMMIT;