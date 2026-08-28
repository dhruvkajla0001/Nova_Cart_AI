-- ============================================================
-- NovaCart AI
-- Seed 002: Value Chains
-- ============================================================

BEGIN;

INSERT INTO value_chains (
    industry_id,
    value_chain_code,
    name,
    description,
    sequence_order
)
SELECT
    i.industry_id,
    v.value_chain_code,
    v.name,
    v.description,
    v.sequence_order
FROM industries i
CROSS JOIN (
    VALUES
        (
            'CUSTOMER_ACQUISITION',
            'Customer Acquisition',
            'Activities involved in attracting prospects, generating demand, and converting potential customers.',
            1
        ),
        (
            'MERCHANDISING_CATALOG',
            'Merchandising & Catalog',
            'Product discovery, catalog management, pricing, assortment, and merchandising activities.',
            2
        ),
        (
            'ORDER_MANAGEMENT',
            'Order Management',
            'Activities involved in capturing, validating, processing, and managing customer orders.',
            3
        ),
        (
            'FULFILLMENT_DELIVERY',
            'Fulfillment & Delivery',
            'Warehouse fulfillment, shipment coordination, logistics, and final delivery.',
            4
        ),
        (
            'PAYMENTS_FRAUD',
            'Payments & Fraud',
            'Payment processing, transaction validation, fraud detection, and financial reconciliation.',
            5
        ),
        (
            'CUSTOMER_SERVICE',
            'Customer Service',
            'Customer support, issue resolution, communication, and service operations.',
            6
        ),
        (
            'POST_PURCHASE_RETURNS',
            'Post-Purchase & Returns',
            'Returns, refunds, exchanges, customer retention, and post-purchase experience.',
            7
        )
) AS v(
    value_chain_code,
    name,
    description,
    sequence_order
)
WHERE i.industry_code = 'ECOMMERCE'

ON CONFLICT (industry_id, value_chain_code) DO NOTHING;

COMMIT;