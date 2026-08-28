-- ============================================================
-- NovaCart AI
-- Seed 001: Industry
-- ============================================================

BEGIN;

INSERT INTO industries (
    industry_code,
    name,
    description
)
VALUES (
    'ECOMMERCE',
    'E-Commerce & Retail',
    'Digital commerce operations covering customer acquisition, merchandising, order management, fulfillment, payments, customer service, and post-purchase operations.'
)
ON CONFLICT (industry_code) DO NOTHING;

COMMIT;