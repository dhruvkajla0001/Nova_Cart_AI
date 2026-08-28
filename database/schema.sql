-- ============================================================
-- NovaCart AI
-- Process × Role × Skill Intelligence Graph
-- Database Schema
-- ============================================================

BEGIN;

-- ============================================================
-- 1. INDUSTRY
-- ============================================================

CREATE TABLE IF NOT EXISTS industries (
    industry_id      BIGSERIAL PRIMARY KEY,
    industry_code    VARCHAR(50) NOT NULL UNIQUE,
    name             VARCHAR(150) NOT NULL,
    description      TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 2. VALUE CHAINS
-- ============================================================

CREATE TABLE IF NOT EXISTS value_chains (
    value_chain_id   BIGSERIAL PRIMARY KEY,
    industry_id      BIGINT NOT NULL REFERENCES industries(industry_id)
                     ON DELETE CASCADE,
    value_chain_code VARCHAR(50) NOT NULL,
    name             VARCHAR(150) NOT NULL,
    description      TEXT,
    sequence_order   INTEGER NOT NULL DEFAULT 0,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_value_chain_code
        UNIQUE (industry_id, value_chain_code)
);

-- ============================================================
-- 3. PROCESSES
-- ============================================================

CREATE TABLE IF NOT EXISTS processes (
    process_id       BIGSERIAL PRIMARY KEY,
    value_chain_id   BIGINT NOT NULL REFERENCES value_chains(value_chain_id)
                     ON DELETE CASCADE,
    process_code     VARCHAR(50) NOT NULL,
    name             VARCHAR(150) NOT NULL,
    description      TEXT,
    sequence_order   INTEGER NOT NULL DEFAULT 0,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_process_code
        UNIQUE (value_chain_id, process_code)
);

-- ============================================================
-- 4. ACTIVITIES
-- ============================================================

CREATE TABLE IF NOT EXISTS activities (
    activity_id      BIGSERIAL PRIMARY KEY,
    process_id       BIGINT NOT NULL REFERENCES processes(process_id)
                     ON DELETE CASCADE,
    activity_code    VARCHAR(50) NOT NULL,
    name             VARCHAR(200) NOT NULL,
    description      TEXT,
    activity_type    VARCHAR(50),
    automation_level NUMERIC(5,2),
    sequence_order   INTEGER NOT NULL DEFAULT 0,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_activity_code
        UNIQUE (process_id, activity_code),

    CONSTRAINT chk_automation_level
        CHECK (
            automation_level IS NULL
            OR (automation_level >= 0 AND automation_level <= 100)
        )
);

-- ============================================================
-- 5. ROLES
-- ============================================================

CREATE TABLE IF NOT EXISTS roles (
    role_id          BIGSERIAL PRIMARY KEY,
    role_code        VARCHAR(50) NOT NULL UNIQUE,
    name             VARCHAR(150) NOT NULL,
    description      TEXT,
    seniority_level  VARCHAR(50),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 6. SKILLS
-- ============================================================

CREATE TABLE IF NOT EXISTS skills (
    skill_id         BIGSERIAL PRIMARY KEY,
    skill_code       VARCHAR(50) NOT NULL UNIQUE,
    name             VARCHAR(150) NOT NULL,
    description      TEXT,
    category         VARCHAR(100),
    skill_type       VARCHAR(50),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 7. ACTIVITY ↔ ROLE
-- ============================================================

CREATE TABLE IF NOT EXISTS activity_roles (
    activity_id      BIGINT NOT NULL REFERENCES activities(activity_id)
                     ON DELETE CASCADE,
    role_id          BIGINT NOT NULL REFERENCES roles(role_id)
                     ON DELETE CASCADE,

    responsibility   VARCHAR(100),
    importance       NUMERIC(5,2),

    PRIMARY KEY (activity_id, role_id),

    CONSTRAINT chk_activity_role_importance
        CHECK (
            importance IS NULL
            OR (importance >= 0 AND importance <= 100)
        )
);

-- ============================================================
-- 8. ROLE ↔ SKILL
-- ============================================================

CREATE TABLE IF NOT EXISTS role_skills (
    role_id          BIGINT NOT NULL REFERENCES roles(role_id)
                     ON DELETE CASCADE,
    skill_id         BIGINT NOT NULL REFERENCES skills(skill_id)
                     ON DELETE CASCADE,

    proficiency_required VARCHAR(50),
    importance           NUMERIC(5,2),

    PRIMARY KEY (role_id, skill_id),

    CONSTRAINT chk_role_skill_importance
        CHECK (
            importance IS NULL
            OR (importance >= 0 AND importance <= 100)
        )
);

-- ============================================================
-- 9. ACTIVITY ↔ SKILL
-- ============================================================

CREATE TABLE IF NOT EXISTS activity_skills (
    activity_id      BIGINT NOT NULL REFERENCES activities(activity_id)
                     ON DELETE CASCADE,
    skill_id         BIGINT NOT NULL REFERENCES skills(skill_id)
                     ON DELETE CASCADE,

    relevance        NUMERIC(5,2),

    PRIMARY KEY (activity_id, skill_id),

    CONSTRAINT chk_activity_skill_relevance
        CHECK (
            relevance IS NULL
            OR (relevance >= 0 AND relevance <= 100)
        )
);

-- ============================================================
-- 10. AI OPPORTUNITIES
-- ============================================================

CREATE TABLE IF NOT EXISTS ai_opportunities (
    ai_opportunity_id BIGSERIAL PRIMARY KEY,

    activity_id       BIGINT NOT NULL REFERENCES activities(activity_id)
                      ON DELETE CASCADE,

    name              VARCHAR(200) NOT NULL,
    description       TEXT NOT NULL,

    ai_type           VARCHAR(100),
    technology        VARCHAR(150),

    automation_score  NUMERIC(5,2),
    augmentation_score NUMERIC(5,2),

    confidence_score  NUMERIC(5,2),

    status            VARCHAR(50) NOT NULL DEFAULT 'identified',

    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_ai_automation_score
        CHECK (
            automation_score IS NULL
            OR (automation_score >= 0 AND automation_score <= 100)
        ),

    CONSTRAINT chk_ai_augmentation_score
        CHECK (
            augmentation_score IS NULL
            OR (augmentation_score >= 0 AND augmentation_score <= 100)
        ),

    CONSTRAINT chk_ai_confidence
        CHECK (
            confidence_score IS NULL
            OR (confidence_score >= 0 AND confidence_score <= 100)
        )
);

-- ============================================================
-- 11. AI IMPACT
-- ============================================================

CREATE TABLE IF NOT EXISTS ai_impacts (
    ai_impact_id      BIGSERIAL PRIMARY KEY,

    ai_opportunity_id BIGINT NOT NULL
                      REFERENCES ai_opportunities(ai_opportunity_id)
                      ON DELETE CASCADE,

    role_id           BIGINT REFERENCES roles(role_id)
                      ON DELETE SET NULL,

    impact_type       VARCHAR(100) NOT NULL,

    impact_score      NUMERIC(5,2),
    description       TEXT,

    affected_workload NUMERIC(5,2),

    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_impact_score
        CHECK (
            impact_score IS NULL
            OR (impact_score >= 0 AND impact_score <= 100)
        ),

    CONSTRAINT chk_affected_workload
        CHECK (
            affected_workload IS NULL
            OR (affected_workload >= 0 AND affected_workload <= 100)
        )
);

-- ============================================================
-- 12. FUTURE ROLES
-- ============================================================

CREATE TABLE IF NOT EXISTS future_roles (
    future_role_id    BIGSERIAL PRIMARY KEY,

    role_id           BIGINT REFERENCES roles(role_id)
                      ON DELETE SET NULL,

    name              VARCHAR(150) NOT NULL,
    description       TEXT,

    emergence_score   NUMERIC(5,2),
    source            VARCHAR(100),

    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_emergence_score
        CHECK (
            emergence_score IS NULL
            OR (emergence_score >= 0 AND emergence_score <= 100)
        )
);

-- ============================================================
-- 13. FUTURE SKILLS
-- ============================================================

CREATE TABLE IF NOT EXISTS future_skills (
    future_skill_id   BIGSERIAL PRIMARY KEY,

    skill_id          BIGINT REFERENCES skills(skill_id)
                      ON DELETE SET NULL,

    name              VARCHAR(150) NOT NULL,
    description       TEXT,

    demand_score      NUMERIC(5,2),
    source            VARCHAR(100),

    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_demand_score
        CHECK (
            demand_score IS NULL
            OR (demand_score >= 0 AND demand_score <= 100)
        )
);

-- ============================================================
-- 14. FUTURE ROLE ↔ FUTURE SKILL
-- ============================================================

CREATE TABLE IF NOT EXISTS future_role_skills (
    future_role_id    BIGINT NOT NULL
                      REFERENCES future_roles(future_role_id)
                      ON DELETE CASCADE,

    future_skill_id   BIGINT NOT NULL
                      REFERENCES future_skills(future_skill_id)
                      ON DELETE CASCADE,

    importance        NUMERIC(5,2),

    PRIMARY KEY (future_role_id, future_skill_id),

    CONSTRAINT chk_future_role_skill_importance
        CHECK (
            importance IS NULL
            OR (importance >= 0 AND importance <= 100)
        )
);

-- ============================================================
-- 15. EVIDENCE / TRACEABILITY
-- ============================================================

CREATE TABLE IF NOT EXISTS evidence (
    evidence_id       BIGSERIAL PRIMARY KEY,

    entity_type       VARCHAR(100) NOT NULL,
    entity_id         BIGINT NOT NULL,

    source_type       VARCHAR(100) NOT NULL,
    source_name       VARCHAR(255),

    source_reference  TEXT,
    evidence_text     TEXT,

    confidence_score  NUMERIC(5,2),

    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_evidence_confidence
        CHECK (
            confidence_score IS NULL
            OR (confidence_score >= 0 AND confidence_score <= 100)
        )
);

-- ============================================================
-- 16. DYNAMIC / SURPRISE RECORDS
-- ============================================================

CREATE TABLE IF NOT EXISTS dynamic_records (
    dynamic_record_id BIGSERIAL PRIMARY KEY,

    entity_type       VARCHAR(100) NOT NULL,
    entity_id         BIGINT,

    record_key        VARCHAR(150) NOT NULL,
    record_value      JSONB NOT NULL,

    source            VARCHAR(100),
    status            VARCHAR(50) NOT NULL DEFAULT 'discovered',

    discovered_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processed_at      TIMESTAMPTZ
);

-- ============================================================
-- 17. AI IMPACT CASCADE
-- ============================================================

CREATE TABLE IF NOT EXISTS ai_impact_cascade (
    cascade_id        BIGSERIAL PRIMARY KEY,

    source_activity_id BIGINT NOT NULL
                       REFERENCES activities(activity_id)
                       ON DELETE CASCADE,

    source_ai_opportunity_id BIGINT
                             REFERENCES ai_opportunities(ai_opportunity_id)
                             ON DELETE SET NULL,

    affected_activity_id BIGINT
                         REFERENCES activities(activity_id)
                         ON DELETE CASCADE,

    affected_role_id BIGINT
                     REFERENCES roles(role_id)
                     ON DELETE CASCADE,

    affected_skill_id BIGINT
                      REFERENCES skills(skill_id)
                      ON DELETE CASCADE,

    impact_level      INTEGER NOT NULL DEFAULT 1,

    impact_score      NUMERIC(5,2),

    reasoning         TEXT,

    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_cascade_level
        CHECK (impact_level >= 1),

    CONSTRAINT chk_cascade_score
        CHECK (
            impact_score IS NULL
            OR (impact_score >= 0 AND impact_score <= 100)
        )
);

COMMIT;