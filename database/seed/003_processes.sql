-- ============================================================
-- NovaCart AI
-- Seed 003: Processes
-- ============================================================

BEGIN;

INSERT INTO processes (
    value_chain_id,
    process_code,
    name,
    description,
    sequence_order
)
SELECT
    vc.value_chain_id,
    p.process_code,
    p.name,
    p.description,
    p.sequence_order
FROM value_chains vc
JOIN (
    VALUES

    -- ========================================================
    -- CUSTOMER ACQUISITION
    -- ========================================================

    ('CUSTOMER_ACQUISITION', 'CA_CAMPAIGN_PLANNING',
     'Campaign Planning',
     'Planning acquisition campaigns, target segments, budgets, and channels.', 1),

    ('CUSTOMER_ACQUISITION', 'CA_DIGITAL_MARKETING',
     'Digital Marketing',
     'Running digital marketing campaigns across paid and organic channels.', 2),

    ('CUSTOMER_ACQUISITION', 'CA_LEAD_CONVERSION',
     'Lead Conversion',
     'Converting prospects into customers through offers, personalization, and engagement.', 3),

    -- ========================================================
    -- MERCHANDISING & CATALOG
    -- ========================================================

    ('MERCHANDISING_CATALOG', 'MC_PRODUCT_ONBOARDING',
     'Product Onboarding',
     'Adding and validating products, attributes, images, and descriptions.', 1),

    ('MERCHANDISING_CATALOG', 'MC_CATALOG_MANAGEMENT',
     'Catalog Management',
     'Maintaining product information, categorization, and catalog quality.', 2),

    ('MERCHANDISING_CATALOG', 'MC_PRICING',
     'Pricing Management',
     'Setting and optimizing product prices based on demand, competition, and margins.', 3),

    ('MERCHANDISING_CATALOG', 'MC_ASSORTMENT',
     'Assortment Planning',
     'Planning product assortment based on customer demand and business strategy.', 4),

    -- ========================================================
    -- ORDER MANAGEMENT
    -- ========================================================

    ('ORDER_MANAGEMENT', 'OM_ORDER_CAPTURE',
     'Order Capture',
     'Capturing customer orders from digital commerce channels.', 1),

    ('ORDER_MANAGEMENT', 'OM_ORDER_VALIDATION',
     'Order Validation',
     'Validating inventory, customer information, pricing, and order conditions.', 2),

    ('ORDER_MANAGEMENT', 'OM_ORDER_PROCESSING',
     'Order Processing',
     'Processing approved orders and preparing them for fulfillment.', 3),

    ('ORDER_MANAGEMENT', 'OM_ORDER_TRACKING',
     'Order Tracking',
     'Monitoring order progress and communicating order status to customers.', 4),

    -- ========================================================
    -- FULFILLMENT & DELIVERY
    -- ========================================================

    ('FULFILLMENT_DELIVERY', 'FD_INVENTORY_ALLOCATION',
     'Inventory Allocation',
     'Allocating available inventory to fulfill customer orders efficiently.', 1),

    ('FULFILLMENT_DELIVERY', 'FD_PICK_PACK',
     'Pick and Pack',
     'Picking products from inventory and preparing shipments.', 2),

    ('FULFILLMENT_DELIVERY', 'FD_SHIPMENT_PROCESSING',
     'Shipment Processing',
     'Preparing shipments, generating shipping information, and handing orders to logistics providers.', 3),

    ('FULFILLMENT_DELIVERY', 'FD_LAST_MILE',
     'Last-Mile Delivery',
     'Managing final delivery of orders to customers.', 4),

    -- ========================================================
    -- PAYMENTS & FRAUD
    -- ========================================================

    ('PAYMENTS_FRAUD', 'PF_PAYMENT_AUTHORIZATION',
     'Payment Authorization',
     'Validating and authorizing customer payment transactions.', 1),

    ('PAYMENTS_FRAUD', 'PF_FRAUD_DETECTION',
     'Fraud Detection',
     'Identifying suspicious transactions and potential payment fraud.', 2),

    ('PAYMENTS_FRAUD', 'PF_PAYMENT_RECONCILIATION',
     'Payment Reconciliation',
     'Reconciling transactions, payments, refunds, and financial records.', 3),

    -- ========================================================
    -- CUSTOMER SERVICE
    -- ========================================================

    ('CUSTOMER_SERVICE', 'CS_INQUIRY_MANAGEMENT',
     'Inquiry Management',
     'Receiving, categorizing, and responding to customer inquiries.', 1),

    ('CUSTOMER_SERVICE', 'CS_ISSUE_RESOLUTION',
     'Issue Resolution',
     'Investigating and resolving customer problems and complaints.', 2),

    ('CUSTOMER_SERVICE', 'CS_CUSTOMER_FEEDBACK',
     'Customer Feedback Management',
     'Collecting, analyzing, and acting on customer feedback.', 3),

    -- ========================================================
    -- POST-PURCHASE & RETURNS
    -- ========================================================

    ('POST_PURCHASE_RETURNS', 'PR_RETURN_REQUEST',
     'Return Request Management',
     'Receiving and validating customer return requests.', 1),

    ('POST_PURCHASE_RETURNS', 'PR_REFUND_PROCESSING',
     'Refund Processing',
     'Processing refunds and validating financial adjustments.', 2),

    ('POST_PURCHASE_RETURNS', 'PR_EXCHANGE',
     'Product Exchange',
     'Managing replacement and exchange requests.', 3),

    ('POST_PURCHASE_RETURNS', 'PR_RETENTION',
     'Customer Retention',
     'Using post-purchase engagement and service activities to improve retention.', 4)

) AS p(
    value_chain_code,
    process_code,
    name,
    description,
    sequence_order
)
ON vc.value_chain_code = p.value_chain_code

ON CONFLICT (value_chain_id, process_code) DO NOTHING;

COMMIT;