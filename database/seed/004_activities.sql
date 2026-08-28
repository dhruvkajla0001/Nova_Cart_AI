-- ============================================================
-- NovaCart AI
-- Seed 004: Activities
-- ============================================================

BEGIN;

INSERT INTO activities (
    process_id,
    activity_code,
    name,
    description,
    activity_type,
    automation_level,
    sequence_order
)
SELECT
    p.process_id,
    a.activity_code,
    a.name,
    a.description,
    a.activity_type,
    a.automation_level,
    a.sequence_order
FROM processes p
JOIN (
    VALUES

    -- ========================================================
    -- CUSTOMER ACQUISITION
    -- ========================================================

    ('CA_CAMPAIGN_PLANNING', 'ACT_CA_001',
     'Define campaign objectives',
     'Define acquisition goals, target outcomes, and campaign success criteria.',
     'PLANNING', 45, 1),

    ('CA_CAMPAIGN_PLANNING', 'ACT_CA_002',
     'Identify target customer segments',
     'Analyze customer characteristics and identify priority acquisition segments.',
     'ANALYSIS', 70, 2),

    ('CA_CAMPAIGN_PLANNING', 'ACT_CA_003',
     'Allocate campaign budget',
     'Allocate marketing budgets across channels and campaign initiatives.',
     'PLANNING', 55, 3),

    ('CA_DIGITAL_MARKETING', 'ACT_CA_004',
     'Create digital campaign content',
     'Develop advertisements, promotional copy, and digital campaign assets.',
     'CREATIVE', 65, 1),

    ('CA_DIGITAL_MARKETING', 'ACT_CA_005',
     'Launch marketing campaigns',
     'Configure and launch campaigns across digital acquisition channels.',
     'EXECUTION', 80, 2),

    ('CA_DIGITAL_MARKETING', 'ACT_CA_006',
     'Monitor campaign performance',
     'Track campaign metrics including impressions, clicks, conversions, and spend.',
     'MONITORING', 90, 3),

    ('CA_DIGITAL_MARKETING', 'ACT_CA_007',
     'Optimize campaign targeting',
     'Adjust targeting parameters based on campaign performance.',
     'OPTIMIZATION', 75, 4),

    ('CA_LEAD_CONVERSION', 'ACT_CA_008',
     'Score prospective customers',
     'Evaluate prospects based on engagement and likelihood to purchase.',
     'ANALYSIS', 85, 1),

    ('CA_LEAD_CONVERSION', 'ACT_CA_009',
     'Personalize customer offers',
     'Create personalized offers based on customer behavior and preferences.',
     'PERSONALIZATION', 80, 2),

    ('CA_LEAD_CONVERSION', 'ACT_CA_010',
     'Track conversion funnel',
     'Monitor customer movement from prospect to completed purchase.',
     'ANALYSIS', 90, 3),

    -- ========================================================
    -- MERCHANDISING & CATALOG
    -- ========================================================

    ('MC_PRODUCT_ONBOARDING', 'ACT_MC_001',
     'Collect product information',
     'Collect product descriptions, specifications, pricing, and media.',
     'DATA_COLLECTION', 70, 1),

    ('MC_PRODUCT_ONBOARDING', 'ACT_MC_002',
     'Validate product attributes',
     'Validate product attributes against catalog requirements.',
     'VALIDATION', 90, 2),

    ('MC_PRODUCT_ONBOARDING', 'ACT_MC_003',
     'Create product listing',
     'Create customer-facing product listings using validated information.',
     'CONTENT', 80, 3),

    ('MC_PRODUCT_ONBOARDING', 'ACT_MC_004',
     'Review product listing quality',
     'Review product listings for completeness, consistency, and accuracy.',
     'QUALITY_CONTROL', 75, 4),

    ('MC_CATALOG_MANAGEMENT', 'ACT_MC_005',
     'Categorize products',
     'Assign products to appropriate categories and catalog structures.',
     'CLASSIFICATION', 90, 1),

    ('MC_CATALOG_MANAGEMENT', 'ACT_MC_006',
     'Detect duplicate products',
     'Identify potentially duplicate product records within the catalog.',
     'DATA_QUALITY', 95, 2),

    ('MC_CATALOG_MANAGEMENT', 'ACT_MC_007',
     'Update product information',
     'Maintain product attributes, descriptions, and catalog information.',
     'DATA_MAINTENANCE', 80, 3),

    ('MC_CATALOG_MANAGEMENT', 'ACT_MC_008',
     'Monitor catalog quality',
     'Monitor completeness and quality of catalog information.',
     'MONITORING', 90, 4),

    ('MC_PRICING', 'ACT_MC_009',
     'Analyze competitor prices',
     'Compare product prices against competitors and market conditions.',
     'ANALYSIS', 90, 1),

    ('MC_PRICING', 'ACT_MC_010',
     'Calculate recommended price',
     'Calculate price recommendations using demand, cost, and market signals.',
     'OPTIMIZATION', 85, 2),

    ('MC_PRICING', 'ACT_MC_011',
     'Review pricing changes',
     'Review proposed pricing changes before publication.',
     'DECISION_SUPPORT', 50, 3),

    ('MC_PRICING', 'ACT_MC_012',
     'Publish product prices',
     'Publish approved product prices to commerce channels.',
     'EXECUTION', 95, 4),

    ('MC_ASSORTMENT', 'ACT_MC_013',
     'Analyze product demand',
     'Analyze historical and current demand patterns across products.',
     'ANALYSIS', 90, 1),

    ('MC_ASSORTMENT', 'ACT_MC_014',
     'Identify assortment gaps',
     'Identify missing products or categories based on customer demand.',
     'ANALYSIS', 80, 2),

    ('MC_ASSORTMENT', 'ACT_MC_015',
     'Recommend product assortment',
     'Generate recommended product assortments based on demand and strategy.',
     'RECOMMENDATION', 75, 3),

    -- ========================================================
    -- ORDER MANAGEMENT
    -- ========================================================

    ('OM_ORDER_CAPTURE', 'ACT_OM_001',
     'Capture customer order',
     'Record customer order information from the commerce channel.',
     'TRANSACTION', 98, 1),

    ('OM_ORDER_CAPTURE', 'ACT_OM_002',
     'Create order record',
     'Create the internal order record and associate customer information.',
     'DATA_ENTRY', 99, 2),

    ('OM_ORDER_CAPTURE', 'ACT_OM_003',
     'Confirm order details',
     'Confirm order contents, pricing, address, and customer details.',
     'VALIDATION', 90, 3),

    ('OM_ORDER_VALIDATION', 'ACT_OM_004',
     'Validate customer information',
     'Validate customer identity, contact information, and delivery details.',
     'VALIDATION', 90, 1),

    ('OM_ORDER_VALIDATION', 'ACT_OM_005',
     'Check inventory availability',
     'Determine whether ordered products are available for fulfillment.',
     'VALIDATION', 98, 2),

    ('OM_ORDER_VALIDATION', 'ACT_OM_006',
     'Validate order pricing',
     'Verify product prices, discounts, taxes, and totals.',
     'VALIDATION', 98, 3),

    ('OM_ORDER_PROCESSING', 'ACT_OM_007',
     'Release order for fulfillment',
     'Release validated orders to downstream fulfillment operations.',
     'EXECUTION', 95, 1),

    ('OM_ORDER_PROCESSING', 'ACT_OM_008',
     'Prioritize orders',
     'Prioritize orders based on customer commitments and operational constraints.',
     'OPTIMIZATION', 80, 2),

    ('OM_ORDER_PROCESSING', 'ACT_OM_009',
     'Handle order exceptions',
     'Investigate and resolve orders that cannot follow the standard workflow.',
     'EXCEPTION_HANDLING', 45, 3),

    ('OM_ORDER_TRACKING', 'ACT_OM_010',
     'Track order status',
     'Monitor order progress across processing and fulfillment stages.',
     'MONITORING', 95, 1),

    ('OM_ORDER_TRACKING', 'ACT_OM_011',
     'Detect delayed orders',
     'Identify orders that are likely to miss expected delivery timelines.',
     'ANOMALY_DETECTION', 90, 2),

    ('OM_ORDER_TRACKING', 'ACT_OM_012',
     'Notify customers about order status',
     'Communicate order status and delivery updates to customers.',
     'COMMUNICATION', 95, 3),

    -- ========================================================
    -- FULFILLMENT & DELIVERY
    -- ========================================================

    ('FD_INVENTORY_ALLOCATION', 'ACT_FD_001',
     'Check available inventory',
     'Determine available inventory across fulfillment locations.',
     'ANALYSIS', 98, 1),

    ('FD_INVENTORY_ALLOCATION', 'ACT_FD_002',
     'Allocate inventory to orders',
     'Assign available inventory to customer orders.',
     'OPTIMIZATION', 90, 2),

    ('FD_INVENTORY_ALLOCATION', 'ACT_FD_003',
     'Resolve inventory shortages',
     'Investigate and resolve orders affected by inventory shortages.',
     'EXCEPTION_HANDLING', 55, 3),

    ('FD_PICK_PACK', 'ACT_FD_004',
     'Generate picking instructions',
     'Generate instructions for warehouse personnel to pick ordered products.',
     'PLANNING', 95, 1),

    ('FD_PICK_PACK', 'ACT_FD_005',
     'Pick products',
     'Retrieve ordered products from warehouse inventory.',
     'PHYSICAL_OPERATION', 30, 2),

    ('FD_PICK_PACK', 'ACT_FD_006',
     'Verify picked products',
     'Verify that the correct products and quantities were picked.',
     'QUALITY_CONTROL', 80, 3),

    ('FD_PICK_PACK', 'ACT_FD_007',
     'Pack customer order',
     'Package products according to shipping and handling requirements.',
     'PHYSICAL_OPERATION', 45, 4),

    ('FD_SHIPMENT_PROCESSING', 'ACT_FD_008',
     'Generate shipment information',
     'Create shipment records and required logistics information.',
     'DATA_PROCESSING', 98, 1),

    ('FD_SHIPMENT_PROCESSING', 'ACT_FD_009',
     'Select logistics provider',
     'Select an appropriate carrier based on delivery requirements and cost.',
     'OPTIMIZATION', 85, 2),

    ('FD_SHIPMENT_PROCESSING', 'ACT_FD_010',
     'Generate shipping label',
     'Generate shipping labels and documentation.',
     'DOCUMENTATION', 99, 3),

    ('FD_LAST_MILE', 'ACT_FD_011',
     'Monitor delivery progress',
     'Track shipments through the final-mile delivery process.',
     'MONITORING', 95, 1),

    ('FD_LAST_MILE', 'ACT_FD_012',
     'Predict delivery delays',
     'Identify shipments at risk of delayed delivery.',
     'PREDICTION', 90, 2),

    ('FD_LAST_MILE', 'ACT_FD_013',
     'Handle delivery exceptions',
     'Investigate failed deliveries and logistics exceptions.',
     'EXCEPTION_HANDLING', 50, 3),

    -- ========================================================
    -- PAYMENTS & FRAUD
    -- ========================================================

    ('PF_PAYMENT_AUTHORIZATION', 'ACT_PF_001',
     'Validate payment details',
     'Validate payment information submitted during checkout.',
     'VALIDATION', 98, 1),

    ('PF_PAYMENT_AUTHORIZATION', 'ACT_PF_002',
     'Authorize payment transaction',
     'Submit payment transactions for authorization.',
     'TRANSACTION', 99, 2),

    ('PF_PAYMENT_AUTHORIZATION', 'ACT_PF_003',
     'Handle payment failures',
     'Investigate and resolve failed payment transactions.',
     'EXCEPTION_HANDLING', 60, 3),

    ('PF_FRAUD_DETECTION', 'ACT_PF_004',
     'Calculate transaction risk score',
     'Evaluate transaction signals and calculate fraud risk.',
     'RISK_ANALYSIS', 95, 1),

    ('PF_FRAUD_DETECTION', 'ACT_PF_005',
     'Investigate suspicious transactions',
     'Review transactions flagged as potentially fraudulent.',
     'INVESTIGATION', 65, 2),

    ('PF_FRAUD_DETECTION', 'ACT_PF_006',
     'Escalate high-risk transactions',
     'Escalate transactions requiring manual fraud review.',
     'DECISION_SUPPORT', 75, 3),

    ('PF_PAYMENT_RECONCILIATION', 'ACT_PF_007',
     'Match payments with orders',
     'Match payment transactions with corresponding customer orders.',
     'RECONCILIATION', 98, 1),

    ('PF_PAYMENT_RECONCILIATION', 'ACT_PF_008',
     'Identify reconciliation discrepancies',
     'Identify differences between payment and order records.',
     'ANOMALY_DETECTION', 95, 2),

    ('PF_PAYMENT_RECONCILIATION', 'ACT_PF_009',
     'Resolve payment discrepancies',
     'Investigate and resolve financial reconciliation issues.',
     'EXCEPTION_HANDLING', 55, 3),

    -- ========================================================
    -- CUSTOMER SERVICE
    -- ========================================================

    ('CS_INQUIRY_MANAGEMENT', 'ACT_CS_001',
     'Receive customer inquiry',
     'Receive customer questions and service requests.',
     'COMMUNICATION', 90, 1),

    ('CS_INQUIRY_MANAGEMENT', 'ACT_CS_002',
     'Classify customer inquiry',
     'Classify inquiries according to issue type and priority.',
     'CLASSIFICATION', 95, 2),

    ('CS_INQUIRY_MANAGEMENT', 'ACT_CS_003',
     'Route inquiry to support team',
     'Route customer inquiries to the appropriate support team or specialist.',
     'ROUTING', 95, 3),

    ('CS_ISSUE_RESOLUTION', 'ACT_CS_004',
     'Investigate customer issue',
     'Investigate customer problems using order and interaction history.',
     'INVESTIGATION', 70, 1),

    ('CS_ISSUE_RESOLUTION', 'ACT_CS_005',
     'Recommend issue resolution',
     'Recommend potential solutions based on issue context and policies.',
     'RECOMMENDATION', 80, 2),

    ('CS_ISSUE_RESOLUTION', 'ACT_CS_006',
     'Resolve customer issue',
     'Resolve customer issues according to service policies.',
     'DECISION_MAKING', 55, 3),

    ('CS_CUSTOMER_FEEDBACK', 'ACT_CS_007',
     'Collect customer feedback',
     'Collect ratings, reviews, comments, and customer feedback.',
     'DATA_COLLECTION', 90, 1),

    ('CS_CUSTOMER_FEEDBACK', 'ACT_CS_008',
     'Analyze customer sentiment',
     'Analyze customer feedback to identify sentiment and recurring themes.',
     'ANALYSIS', 90, 2),

    ('CS_CUSTOMER_FEEDBACK', 'ACT_CS_009',
     'Identify recurring customer problems',
     'Identify repeated customer issues and potential root causes.',
     'PATTERN_ANALYSIS', 85, 3),

    -- ========================================================
    -- POST-PURCHASE & RETURNS
    -- ========================================================

    ('PR_RETURN_REQUEST', 'ACT_PR_001',
     'Receive return request',
     'Receive customer requests to return purchased products.',
     'COMMUNICATION', 95, 1),

    ('PR_RETURN_REQUEST', 'ACT_PR_002',
     'Validate return eligibility',
     'Determine whether a return satisfies applicable return policies.',
     'VALIDATION', 90, 2),

    ('PR_RETURN_REQUEST', 'ACT_PR_003',
     'Approve or reject return',
     'Make a return authorization decision based on policy and order information.',
     'DECISION_MAKING', 70, 3),

    ('PR_REFUND_PROCESSING', 'ACT_PR_004',
     'Validate refund amount',
     'Validate refund calculations against order and return information.',
     'VALIDATION', 95, 1),

    ('PR_REFUND_PROCESSING', 'ACT_PR_005',
     'Process customer refund',
     'Initiate and record approved customer refunds.',
     'TRANSACTION', 98, 2),

    ('PR_REFUND_PROCESSING', 'ACT_PR_006',
     'Reconcile refund transaction',
     'Reconcile refunds with payment and order records.',
     'RECONCILIATION', 95, 3),

    ('PR_EXCHANGE', 'ACT_PR_007',
     'Validate exchange request',
     'Validate product exchange eligibility and requested replacement.',
     'VALIDATION', 90, 1),

    ('PR_EXCHANGE', 'ACT_PR_008',
     'Allocate replacement product',
     'Identify and allocate inventory for product replacements.',
     'OPTIMIZATION', 85, 2),

    ('PR_EXCHANGE', 'ACT_PR_009',
     'Process product exchange',
     'Complete the product replacement transaction.',
     'TRANSACTION', 90, 3),

    ('PR_RETENTION', 'ACT_PR_010',
     'Identify at-risk customers',
     'Identify customers showing signals of reduced engagement or churn.',
     'PREDICTION', 85, 1),

    ('PR_RETENTION', 'ACT_PR_011',
     'Recommend retention action',
     'Recommend targeted actions to improve customer retention.',
     'RECOMMENDATION', 80, 2),

    ('PR_RETENTION', 'ACT_PR_012',
     'Launch retention campaign',
     'Execute targeted retention campaigns for selected customer segments.',
     'EXECUTION', 85, 3)

) AS a(
    process_code,
    activity_code,
    name,
    description,
    activity_type,
    automation_level,
    sequence_order
)
ON p.process_code = a.process_code

ON CONFLICT (process_id, activity_code) DO NOTHING;

COMMIT;