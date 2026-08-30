import { useEffect, useMemo, useState } from "react";
import "./App.css";

const API_BASE = "http://127.0.0.1:8000";

function App() {
  // ============================================================
  // ENTERPRISE GRAPH
  // ============================================================

  const [industries, setIndustries] = useState([]);
  const [valueChains, setValueChains] = useState([]);
  const [processes, setProcesses] = useState([]);
  const [activities, setActivities] = useState([]);

  const [selectedIndustry, setSelectedIndustry] =
    useState(null);

  const [selectedValueChain, setSelectedValueChain] =
    useState(null);

  const [selectedProcess, setSelectedProcess] =
    useState(null);

  const [selectedActivity, setSelectedActivity] =
    useState(null);

  // ============================================================
  // AI STATE
  // ============================================================

  const [analysis, setAnalysis] = useState(null);
  const [cascade, setCascade] = useState(null);

  const [analysisLoading, setAnalysisLoading] =
    useState(false);

  const [cascadeLoading, setCascadeLoading] =
    useState(false);

  const [reasoningLoading, setReasoningLoading] =
    useState(false);

  const [error, setError] = useState("");

  // ============================================================
  // SURPRISE RECORD
  // ============================================================

  const [showSurprise, setShowSurprise] =
    useState(false);

  const [ingestionLoading, setIngestionLoading] =
    useState(false);

  const [ingestionResult, setIngestionResult] =
    useState(null);

  const [newActivity, setNewActivity] = useState({
    process_id: "",
    name: "",
    description: "",
    activity_type: "",
  });

  // ============================================================
  // EXPANSION STATE
  // ============================================================

  const [showAllRoles, setShowAllRoles] =
    useState(false);

  const [showAllSkills, setShowAllSkills] =
    useState(false);

  const [showAllActivities, setShowAllActivities] =
    useState(false);

  const [showAllFutureRoles, setShowAllFutureRoles] =
    useState(false);

  const [showAllFutureSkills, setShowAllFutureSkills] =
    useState(false);

  // ============================================================
  // API
  // ============================================================

  async function apiFetch(endpoint, options = {}) {
    const response = await fetch(
      `${API_BASE}${endpoint}`,
      {
        ...options,
        headers: {
          "Content-Type": "application/json",
          ...(options.headers || {}),
        },
      }
    );

    if (!response.ok) {
      let message =
        `Request failed (${response.status})`;

      try {
        const body = await response.json();

        if (typeof body?.detail === "string") {
          message = body.detail;
        }
      } catch {
        // Keep default message.
      }

      throw new Error(message);
    }

    return response.json();
  }

  // ============================================================
  // INITIAL LOAD
  // ============================================================

  useEffect(() => {
    loadIndustries();
  }, []);

  async function loadIndustries() {
    try {
      setError("");

      const data = await apiFetch(
        "/api/industries"
      );

      setIndustries(
        Array.isArray(data) ? data : []
      );
    } catch (err) {
      setError(
        `Unable to load industries: ${err.message}`
      );
    }
  }

  // ============================================================
  // RESET ANALYSIS
  // ============================================================

  function resetAnalysis() {
    setAnalysis(null);
    setCascade(null);
    setShowAllRoles(false);
    setShowAllSkills(false);
    setShowAllActivities(false);
    setShowAllFutureRoles(false);
    setShowAllFutureSkills(false);
  }

  // ============================================================
  // INDUSTRY
  // ============================================================

  async function selectIndustry(industry) {
    setSelectedIndustry(industry);

    setSelectedValueChain(null);
    setSelectedProcess(null);
    setSelectedActivity(null);

    setValueChains([]);
    setProcesses([]);
    setActivities([]);

    resetAnalysis();

    if (!industry) {
      return;
    }

    try {
      const data = await apiFetch(
        `/api/industries/${industry.industry_id}/value-chains`
      );

      setValueChains(
        Array.isArray(data) ? data : []
      );
    } catch (err) {
      setError(
        `Unable to load value chains: ${err.message}`
      );
    }
  }

  // ============================================================
  // VALUE CHAIN
  // ============================================================

  async function selectValueChain(valueChain) {
    setSelectedValueChain(valueChain);

    setSelectedProcess(null);
    setSelectedActivity(null);

    setProcesses([]);
    setActivities([]);

    resetAnalysis();

    if (!valueChain) {
      return;
    }

    try {
      const data = await apiFetch(
        `/api/value-chains/${valueChain.value_chain_id}/processes`
      );

      setProcesses(
        Array.isArray(data) ? data : []
      );
    } catch (err) {
      setError(
        `Unable to load processes: ${err.message}`
      );
    }
  }

  // ============================================================
  // PROCESS
  // ============================================================

  async function selectProcess(process) {
    setSelectedProcess(process);

    setSelectedActivity(null);

    setActivities([]);

    resetAnalysis();

    if (!process) {
      return;
    }

    try {
      const data = await apiFetch(
        `/api/processes/${process.process_id}/activities`
      );

      setActivities(
        Array.isArray(data) ? data : []
      );
    } catch (err) {
      setError(
        `Unable to load activities: ${err.message}`
      );
    }
  }

  // ============================================================
  // ACTIVITY
  // ============================================================

  async function selectActivity(activity) {
    setSelectedActivity(activity);

    resetAnalysis();

    if (!activity) {
      return;
    }

    await Promise.all([
      loadAnalysis(
        activity.activity_id
      ),
      loadCascade(
        activity.activity_id
      ),
      loadReasoning(
        activity.activity_id
      ),
    ]);
  }

  // ============================================================
  // AI ANALYSIS
  // ============================================================

  async function loadAnalysis(activityId) {
    try {
      setAnalysisLoading(true);
      setError("");

      const data = await apiFetch(
        `/api/ai-analysis/activities/${activityId}`
      );

      console.log(
        "NovaCart AI Analysis Response:",
        data
      );

      setAnalysis(data);
    } catch (err) {
      console.error(err);

      setAnalysis(null);

      setError(
        `AI analysis failed: ${err.message}`
      );
    } finally {
      setAnalysisLoading(false);
    }
  }

  // ============================================================
  // RUNTIME LLM REASONING
  // ============================================================

  async function loadReasoning(activityId) {
    try {
      setReasoningLoading(true);

      const data = await apiFetch(
        `/api/ai-analysis/activities/${activityId}/reason`,
        {
          method: "POST",
          body: JSON.stringify({}),
        }
      );

      console.log(
        "NovaCart Llama Reasoning Response:",
        data
      );

      setAnalysis((current) => ({
        ...(current || {}),
        ...data,
        llm_reasoning:
          data?.llm_reasoning ||
          current?.llm_reasoning,
        classification:
          data?.classification ||
          current?.classification,
        analysis:
          data?.analysis ||
          current?.analysis,
        graph_context:
          data?.graph_context ||
          current?.graph_context,
      }));
    } catch (err) {
      console.error(
        "NovaCart Llama Reasoning Error:",
        err
      );

      // Do not destroy deterministic AI analysis if
      // the local LLM is unavailable.
      setAnalysis((current) => ({
        ...(current || {}),
        llm_reasoning: {
          provider: "ollama",
          model: "llama3.2:latest",
          status: "error",
          error: err.message,
        },
      }));
    } finally {
      setReasoningLoading(false);
    }
  }

  // ============================================================
  // CASCADE
  // ============================================================

  async function loadCascade(activityId) {
    try {
      setCascadeLoading(true);

      const data = await apiFetch(
        `/api/ai-analysis/activities/${activityId}/cascade`
      );

      console.log(
        "NovaCart AI Cascade Response:",
        data
      );

      setCascade(data);
    } catch (err) {
      console.error(err);

      setCascade(null);

      setError(
        `Impact cascade failed: ${err.message}`
      );
    } finally {
      setCascadeLoading(false);
    }
  }

  // ============================================================
  // SURPRISE RECORD
  // ============================================================

  async function submitSurprise(event) {
    event.preventDefault();

    if (!newActivity.process_id) {
      setError("Please select a process.");
      return;
    }

    if (!newActivity.name.trim()) {
      setError("Activity name is required.");
      return;
    }

    try {
      setIngestionLoading(true);
      setError("");
      setIngestionResult(null);

      const payload = {
        process_id: Number(
          newActivity.process_id
        ),
        name: newActivity.name.trim(),
        description:
          newActivity.description.trim(),
        activity_type:
          newActivity.activity_type.trim() ||
          null,
      };

      const result = await apiFetch(
        "/api/ingestion/activities",
        {
          method: "POST",
          body: JSON.stringify(payload),
        }
      );

      console.log(
        "NovaCart Ingestion Response:",
        result
      );

      setIngestionResult(result);

      // Refresh activities.
      if (
        selectedProcess &&
        Number(
          selectedProcess.process_id
        ) === Number(payload.process_id)
      ) {
        const refreshed =
          await apiFetch(
            `/api/processes/${payload.process_id}/activities`
          );

        setActivities(
          Array.isArray(refreshed)
            ? refreshed
            : []
        );
      }

      // Automatically analyze new record.
      if (result?.activity) {
        const created =
          result.activity;

        setSelectedActivity(created);

        resetAnalysis();

        await Promise.all([
          loadAnalysis(
            created.activity_id
          ),
          loadCascade(
            created.activity_id
          ),
          loadReasoning(
            created.activity_id
          ),
        ]);
      }

      setNewActivity({
        process_id:
          newActivity.process_id,
        name: "",
        description: "",
        activity_type: "",
      });
    } catch (err) {
      setError(
        `Unable to process activity: ${err.message}`
      );
    } finally {
      setIngestionLoading(false);
    }
  }

  // ============================================================
  // NORMALIZE AI RESPONSE
  // ============================================================

  const aiRoot =
    analysis?.analysis ||
    analysis ||
    {};

  const classification =
    analysis?.classification ||
    aiRoot?.classification ||
    {};

  const assessment =
    aiRoot?.ai_assessment ||
    analysis?.ai_assessment ||
    {};

  const opportunity =
    aiRoot?.ai_opportunity ||
    analysis?.ai_opportunity ||
    null;

  const llm =
    analysis?.llm_reasoning ||
    {};

  const reasoning =
    llm?.reasoning ||
    null;

  const llmAvailable =
    llm?.status === "success" &&
    reasoning !== null;

  const llmError =
    llm?.error ||
    null;

  // ============================================================
  // GRAPH CONTEXT
  // ============================================================

  const graphContext =
    analysis?.graph_context ||
    {};

  const roles =
    graphContext?.roles ||
    [];

  const skills =
    graphContext?.skills ||
    [];

  // ============================================================
  // CASCADE
  // ============================================================

  const cascadeRoot =
    cascade?.cascade ||
    cascade ||
    {};

  const cascadeSummary =
    cascade?.summary ||
    cascadeRoot?.summary ||
    {};

  const directImpact =
    cascadeRoot?.level_1_direct ||
    [];

  const roleActivityImpact =
    cascadeRoot?.level_2_role_activity ||
    [];

  const skillImpact =
    cascadeRoot?.level_3_skill ||
    [];

  const futureRoleImpact =
    cascadeRoot?.level_4_future_role ||
    [];

  const futureSkillImpact =
    cascadeRoot?.level_5_future_skill ||
    [];

  const allCascadeRecords = [
    ...directImpact,
    ...roleActivityImpact,
    ...skillImpact,
    ...futureRoleImpact,
    ...futureSkillImpact,
  ];

  // ============================================================
  // CASCADE NORMALIZATION
  // ============================================================
  //
  // The backend may place role/skill impacts in different
  // cascade levels depending on how the record was created.
  // Runtime ingestion currently creates direct role/skill
  // records at level 1, while pre-computed cascades can use
  // levels 2–5.
  //
  // Therefore the UI must identify entities by their IDs /
  // nested objects rather than assuming a specific level.
  // PostgreSQL remains the source of truth.
  // ============================================================

  function getRecordEntityId(record, type) {
    if (!record) {
      return null;
    }

    if (type === "role") {
      return (
        record?.affected_role_id ??
        record?.role_id ??
        record?.affected_role?.role_id ??
        record?.role?.role_id ??
        null
      );
    }

    if (type === "skill") {
      return (
        record?.affected_skill_id ??
        record?.skill_id ??
        record?.affected_skill?.skill_id ??
        record?.skill?.skill_id ??
        null
      );
    }

    if (type === "activity") {
      return (
        record?.affected_activity_id ??
        record?.activity_id ??
        record?.affected_activity?.activity_id ??
        record?.activity?.activity_id ??
        null
      );
    }

    return null;
  }

  function normalizeId(value) {
    if (
      value === null ||
      value === undefined ||
      value === ""
    ) {
      return null;
    }

    const numeric = Number(value);

    return Number.isNaN(numeric)
      ? String(value)
      : numeric;
  }

  // ============================================================
  // IMPACT ROLE DATA
  // ============================================================

  const impactedRoles = useMemo(() => {
    const map = new Map();

    // First use actual cascade records.
    allCascadeRecords.forEach(
      (record) => {
        const id = normalizeId(
          getRecordEntityId(
            record,
            "role"
          )
        );

        if (id === null) {
          return;
        }

        if (!map.has(id)) {
          map.set(id, {
            ...record,
            affected_role_id: id,
          });
        }
      }
    );

    // Runtime ingestion can create role impacts at level 1.
    // If records contain only IDs, resolve their presentation
    // data from the verified graph context.
    roles.forEach(
      (role) => {
        const id = normalizeId(
          role?.role_id
        );

        if (
          id !== null &&
          !map.has(id) &&
          (
            Number(
              cascadeSummary.level_1_count || 0
            ) > 0 ||
            Number(
              cascadeSummary.level_2_count || 0
            ) > 0
          )
        ) {
          map.set(id, {
            affected_role_id: id,
            affected_role: role,
            impact_score:
              assessment?.automation_score,
            impact_level: 1,
          });
        }
      }
    );

    return Array.from(
      map.values()
    );
  }, [
    cascade,
    roles,
    cascadeSummary,
    assessment?.automation_score,
  ]);

  // ============================================================
  // IMPACT SKILL DATA
  // ============================================================

  const impactedSkills = useMemo(() => {
    const map = new Map();

    allCascadeRecords.forEach(
      (record) => {
        const id = normalizeId(
          getRecordEntityId(
            record,
            "skill"
          )
        );

        if (id === null) {
          return;
        }

        if (!map.has(id)) {
          map.set(id, {
            ...record,
            affected_skill_id: id,
          });
        }
      }
    );

    // Same runtime-ingestion fallback for skills.
    skills.forEach(
      (skill) => {
        const id = normalizeId(
          skill?.skill_id
        );

        if (
          id !== null &&
          !map.has(id) &&
          (
            Number(
              cascadeSummary.level_1_count || 0
            ) > 0 ||
            Number(
              cascadeSummary.level_3_count || 0
            ) > 0
          )
        ) {
          map.set(id, {
            affected_skill_id: id,
            affected_skill: skill,
            impact_score:
              assessment?.augmentation_score,
            impact_level: 1,
          });
        }
      }
    );

    return Array.from(
      map.values()
    );
  }, [
    cascade,
    skills,
    cascadeSummary,
    assessment?.augmentation_score,
  ]);

  // ============================================================
  // SECONDARY / RELATED ACTIVITY DATA
  // ============================================================

  const impactedActivities = useMemo(() => {
    const map = new Map();

    allCascadeRecords.forEach(
      (record) => {
        const id = normalizeId(
          getRecordEntityId(
            record,
            "activity"
          )
        );

        if (
          id === null ||
          id === normalizeId(
            selectedActivity?.activity_id
          )
        ) {
          return;
        }

        if (!map.has(id)) {
          map.set(id, {
            ...record,
            affected_activity_id: id,
          });
        }
      }
    );

    return Array.from(
      map.values()
    );
  }, [
    cascade,
    selectedActivity,
  ]);

  const futureRoles =
    Array.isArray(futureRoleImpact)
      ? futureRoleImpact
      : [];

  const futureSkills =
    Array.isArray(futureSkillImpact)
      ? futureSkillImpact
      : [];

  // ============================================================
  // PRESENTATION COUNTS
  // ============================================================

  // Prefer backend summary values when they exist.
  // For runtime level-1 records, derive role/skill counts
  // from the normalized entity arrays when the summary
  // uses different level semantics.
  const cascadeRoleCount =
    Math.max(
      Number(
        cascadeSummary.level_2_count || 0
      ),
      impactedRoles.length
    );

  const cascadeSkillCount =
    Math.max(
      Number(
        cascadeSummary.level_3_count || 0
      ),
      impactedSkills.length
    );

  const cascadeFutureCount =
    Math.max(
      Number(
        cascadeSummary.level_4_count || 0
      ),
      futureRoles.length
    ) +
    Math.max(
      Number(
        cascadeSummary.level_5_count || 0
      ),
      futureSkills.length
    );

  const cascadeTotalCount =
    Math.max(
      Number(
        cascadeSummary.total_cascade_records || 0
      ),
      allCascadeRecords.length
    );

  // ============================================================
  // HELPERS
  // ============================================================

  function score(value) {
    if (
      value === null ||
      value === undefined ||
      value === ""
    ) {
      return "—";
    }

    return `${Math.round(
      Number(value)
    )}%`;
  }

  function confidence(value) {
    if (
      value === null ||
      value === undefined ||
      value === ""
    ) {
      return "—";
    }

    const n = Number(value);

    return `${Math.round(
      n <= 1 ? n * 100 : n
    )}%`;
  }

  function scoreClass(value) {
    const n = Number(value || 0);

    if (n >= 75) {
      return "high";
    }

    if (n >= 50) {
      return "medium";
    }

    return "low";
  }

  function findRole(roleId) {
    return roles.find(
      (role) =>
        Number(role.role_id) ===
        Number(roleId)
    );
  }

  function findSkill(skillId) {
    return skills.find(
      (skill) =>
        Number(skill.skill_id) ===
        Number(skillId)
    );
  }

  // ============================================================
  // RENDER
  // ============================================================

  return (
    <div className="app">

      {/* ======================================================
          HEADER
      ====================================================== */}

      <header className="topbar">

        <div className="brand">

          <div className="brand-mark">
            N
          </div>

          <div>

            <h1>
              NovaCart <span>AI</span>
            </h1>

            <p>
              Workforce Intelligence Platform
            </p>

          </div>

        </div>

        <div className="system-status">

          <span className="online-dot" />

          <span>
            LOCAL AI ONLINE
          </span>

          <small>
            Llama 3.2
          </small>

        </div>

      </header>

      {/* ======================================================
          ERROR
      ====================================================== */}

      {error && (

        <div className="notification">

          <div>
            <strong>
              System message
            </strong>

            <span>
              {error}
            </span>
          </div>

          <button
            onClick={() =>
              setError("")
            }
          >
            ×
          </button>

        </div>

      )}

      <main>

        {/* ====================================================
            HERO
        ==================================================== */}

        <section className="hero">

          <div className="hero-copy">

            <span className="eyebrow">
              ENTERPRISE AI INTELLIGENCE
            </span>

            <h2>
              See how AI transforms
              <span>
                enterprise work.
              </span>
            </h2>

            <p>
              Explore the enterprise graph,
              evaluate AI opportunities and
              understand workforce impact
              through runtime intelligence.
            </p>

          </div>

          <div className="hero-metrics">

            <div>
              <strong>
                {industries.length}
              </strong>

              <span>
                Industries
              </span>
            </div>

            <div>
              <strong>
                {processes.length}
              </strong>

              <span>
                Processes
              </span>
            </div>

            <div>
              <strong>
                {activities.length}
              </strong>

              <span>
                Activities
              </span>
            </div>

          </div>

        </section>

        {/* ====================================================
            GRAPH EXPLORER
        ==================================================== */}

        <section className="panel explorer">

          <div className="panel-heading">

            <div>

              <span className="eyebrow">
                01 · GRAPH EXPLORER
              </span>

              <h2>
                Navigate enterprise work
              </h2>

            </div>

            <span className="panel-status">
              PostgreSQL Graph
            </span>

          </div>

          <div className="selector-row">

            {/* INDUSTRY */}

            <div className="selector">

              <label>
                Industry
              </label>

              <select
                value={
                  selectedIndustry
                    ?.industry_id || ""
                }
                onChange={(event) => {

                  const id =
                    Number(
                      event.target.value
                    );

                  const item =
                    industries.find(
                      (x) =>
                        Number(
                          x.industry_id
                        ) === id
                    ) || null;

                  selectIndustry(item);
                }}
              >

                <option value="">
                  Select industry
                </option>

                {industries.map(
                  (industry) => (

                    <option
                      key={
                        industry.industry_id
                      }
                      value={
                        industry.industry_id
                      }
                    >
                      {industry.name}
                    </option>

                  )
                )}

              </select>

            </div>

            <div className="selector-arrow">
              →
            </div>

            {/* VALUE CHAIN */}

            <div className="selector">

              <label>
                Value Chain
              </label>

              <select
                disabled={
                  !selectedIndustry
                }
                value={
                  selectedValueChain
                    ?.value_chain_id ||
                  ""
                }
                onChange={(event) => {

                  const id =
                    Number(
                      event.target.value
                    );

                  const item =
                    valueChains.find(
                      (x) =>
                        Number(
                          x.value_chain_id
                        ) === id
                    ) || null;

                  selectValueChain(item);
                }}
              >

                <option value="">
                  Select value chain
                </option>

                {valueChains.map(
                  (item) => (

                    <option
                      key={
                        item.value_chain_id
                      }
                      value={
                        item.value_chain_id
                      }
                    >
                      {item.name}
                    </option>

                  )
                )}

              </select>

            </div>

            <div className="selector-arrow">
              →
            </div>

            {/* PROCESS */}

            <div className="selector">

              <label>
                Process
              </label>

              <select
                disabled={
                  !selectedValueChain
                }
                value={
                  selectedProcess
                    ?.process_id || ""
                }
                onChange={(event) => {

                  const id =
                    Number(
                      event.target.value
                    );

                  const item =
                    processes.find(
                      (x) =>
                        Number(
                          x.process_id
                        ) === id
                    ) || null;

                  selectProcess(item);
                }}
              >

                <option value="">
                  Select process
                </option>

                {processes.map(
                  (item) => (

                    <option
                      key={
                        item.process_id
                      }
                      value={
                        item.process_id
                      }
                    >
                      {item.name}
                    </option>

                  )
                )}

              </select>

            </div>

            <div className="selector-arrow">
              →
            </div>

            {/* ACTIVITY */}

            <div className="selector">

              <label>
                Activity
              </label>

              <select
                disabled={
                  !selectedProcess
                }
                value={
                  selectedActivity
                    ?.activity_id || ""
                }
                onChange={(event) => {

                  const id =
                    Number(
                      event.target.value
                    );

                  const item =
                    activities.find(
                      (x) =>
                        Number(
                          x.activity_id
                        ) === id
                    ) || null;

                  selectActivity(item);
                }}
              >

                <option value="">
                  Select activity
                </option>

                {activities.map(
                  (item) => (

                    <option
                      key={
                        item.activity_id
                      }
                      value={
                        item.activity_id
                      }
                    >
                      {item.name}
                    </option>

                  )
                )}

              </select>

            </div>

          </div>

        </section>

        {/* ====================================================
            ACTIVITY HEADER
        ==================================================== */}

        {selectedActivity && (

          <section className="activity-banner">

            <div>

              <span className="eyebrow">
                SELECTED ACTIVITY
              </span>

              <h2>
                {selectedActivity.name}
              </h2>

              <p>
                {selectedActivity.description ||
                  "No description available."}
              </p>

            </div>

            <div className="activity-tags">

              <span>
                {selectedActivity.activity_type ||
                  "ACTIVITY"}
              </span>

              <span>
                ID #{selectedActivity.activity_id}
              </span>

            </div>

          </section>

        )}

        {/* ====================================================
            LOADING
        ==================================================== */}

        {selectedActivity &&
          analysisLoading && (

            <section className="panel loading-card">

              <div className="loader" />

              <div>

                <span className="eyebrow">
                  RUNTIME INTELLIGENCE
                </span>

                <h3>
                  Analyzing enterprise activity
                </h3>

                <p>
                  Classification → AI assessment
                  → graph context → Llama reasoning
                </p>

              </div>

            </section>

          )}

        {/* ====================================================
            AI ASSESSMENT
        ==================================================== */}

        {analysis &&
          !analysisLoading && (

            <section className="panel">

              <div className="panel-heading">

                <div>

                  <span className="eyebrow">
                    02 · AI ASSESSMENT
                  </span>

                  <h2>
                    Transformation potential
                  </h2>

                </div>

                <span className="confidence-badge">
                  {confidence(
                    assessment.confidence
                  )} confidence
                </span>

              </div>

              <div className="score-grid">

                <div className="score-card">

                  <span>
                    AUTOMATION
                  </span>

                  <strong
                    className={scoreClass(
                      assessment.automation_score
                    )}
                  >
                    {score(
                      assessment.automation_score
                    )}
                  </strong>

                  <div className="score-bar">

                    <span
                      style={{
                        width: `${Number(
                          assessment.automation_score ||
                            0
                        )}%`,
                      }}
                    />

                  </div>

                  <small>
                    Potential for AI-driven
                    automation
                  </small>

                </div>

                <div className="score-card">

                  <span>
                    AUGMENTATION
                  </span>

                  <strong
                    className={scoreClass(
                      assessment.augmentation_score
                    )}
                  >
                    {score(
                      assessment.augmentation_score
                    )}
                  </strong>

                  <div className="score-bar">

                    <span
                      style={{
                        width: `${Number(
                          assessment.augmentation_score ||
                            0
                        )}%`,
                      }}
                    />

                  </div>

                  <small>
                    Potential to enhance
                    human performance
                  </small>

                </div>

                <div className="score-card mode">

                  <span>
                    AI MODE
                  </span>

                  <strong>
                    {assessment.ai_mode ||
                      "—"}
                  </strong>

                  <small>
                    Recommended transformation
                    pattern
                  </small>

                </div>

                <div className="score-card">

                  <span>
                    CLASSIFICATION
                  </span>

                  <strong>
                    {classification.category ||
                      "Unknown"}
                  </strong>

                  <small>
                    Confidence{" "}
                    {confidence(
                      classification.confidence
                    )}
                  </small>

                </div>

              </div>

              {/* AI OPPORTUNITY */}

              <div className="opportunity-card">

                <div className="opportunity-icon">
                  ✦
                </div>

                <div className="opportunity-content">

                  <span className="eyebrow">
                    PRIMARY AI OPPORTUNITY
                  </span>

                  <h3>
                    {opportunity?.name ||
                      "No opportunity identified"}
                  </h3>

                  <p>
                    {opportunity?.technology ||
                      "No technology recommendation available."}
                  </p>

                </div>

                {opportunity?.ai_type && (

                  <span className="type-pill">
                    {opportunity.ai_type}
                  </span>

                )}

              </div>

            </section>

          )}

        {/* ====================================================
            LLM REASONING
        ==================================================== */}

        {analysis &&
          !analysisLoading && (

            <section className="panel reasoning-panel">

              <div className="panel-heading">

                <div>

                  <span className="eyebrow">
                    03 · RUNTIME AI REASONING
                  </span>

                  <h2>
                    Llama 3.2 Analysis
                  </h2>

                </div>

                <span
                  className={
                    llmAvailable
                      ? "llm-status active"
                      : "llm-status"
                  }
                >
                  {reasoningLoading
                    ? "◌ GENERATING REASONING"
                    : llmAvailable
                    ? "● LOCAL MODEL ACTIVE"
                    : "○ MODEL UNAVAILABLE"}
                </span>

              </div>

              {reasoningLoading && !llmAvailable && (

                <div className="reasoning-loading">

                  <div className="loader small" />

                  <div>
                    <strong>
                      Llama 3.2 is analyzing this activity...
                    </strong>

                    <span>
                      Running local enterprise reasoning from verified graph context.
                    </span>
                  </div>

                </div>

              )}

              {llmAvailable ? (

                <>

                  <div className="executive-card">

                    <div className="executive-mark">
                      ✦
                    </div>

                    <div>

                      <span className="eyebrow">
                        EXECUTIVE SUMMARY
                      </span>

                      <p>
                        {reasoning.summary ||
                          "No summary returned."}
                      </p>

                    </div>

                  </div>

                  <div className="reasoning-grid">

                    <ReasoningCard
                      title="Automation"
                      text={
                        reasoning.automation_reasoning
                      }
                    />

                    <ReasoningCard
                      title="Augmentation"
                      text={
                        reasoning.augmentation_reasoning
                      }
                    />

                    <ReasoningCard
                      title="Human Role"
                      text={
                        reasoning.human_role
                      }
                    />

                    <ReasoningCard
                      title="Skill Change"
                      text={
                        reasoning.skill_change
                      }
                    />

                    <ReasoningCard
                      title="Future Outlook"
                      text={
                        reasoning.future_outlook
                      }
                      wide
                    />

                    <ReasoningCard
                      title="Model Confidence"
                      text={confidence(
                        reasoning.confidence
                      )}
                      confidence
                    />

                  </div>

                </>

              ) : (

                <div className="llm-error">

                  <div className="llm-error-mark">
                    !
                  </div>

                  <div>

                    <h3>
                      Local reasoning unavailable
                    </h3>

                    <p>
                      {llmError ||
                        "The deterministic AI assessment is available, but the local Llama model did not return reasoning."}
                    </p>

                    <small>
                      Provider:{" "}
                      {llm.provider ||
                        "Ollama"}
                      {" · "}
                      Model:{" "}
                      {llm.model ||
                        "llama3.2:latest"}
                    </small>

                  </div>

                </div>

              )}

            </section>

          )}

        {/* ====================================================
            IMPACT CASCADE
        ==================================================== */}

        {selectedActivity && (

          <section className="panel cascade-panel">

            <div className="panel-heading">

              <div>

                <span className="eyebrow">
                  04 · WORKFORCE IMPACT
                </span>

                <h2>
                  AI impact cascade
                </h2>

                <p>
                  Trace how the selected activity
                  propagates through roles and skills.
                </p>

              </div>

              {cascadeLoading && (
                <span className="loading-label">
                  Resolving graph...
                </span>
              )}

            </div>

            {/* CASCADE SUMMARY */}

            <div className="cascade-summary">

              <ImpactMetric
                label="TOTAL IMPACT"
                value={
                  cascadeTotalCount
                }
              />

              <ImpactMetric
                label="DIRECT"
                value={
                  cascadeSummary.level_1_count ||
                  0
                }
              />

              <ImpactMetric
                label="ROLES"
                value={
                  cascadeRoleCount
                }
              />

              <ImpactMetric
                label="SKILLS"
                value={
                  cascadeSkillCount
                }
              />

              <ImpactMetric
                label="FUTURE SKILLS"
                value={
                  cascadeSummary.level_5_count ||
                  0
                }
              />

            </div>

            {/* CASCADE VISUAL */}

            <div className="cascade-path">

              <CascadeNode
                number="01"
                label="ACTIVITY"
                title={
                  selectedActivity.name
                }
              />

              <CascadeArrow />

              <CascadeNode
                number="02"
                label="AI OPPORTUNITY"
                title={
                  opportunity?.name ||
                  "AI transformation"
                }
              />

              <CascadeArrow />

              <CascadeNode
                number="03"
                label="WORKFORCE"
                title={`${cascadeRoleCount} roles · ${cascadeSkillCount} skills`}
              />

            </div>

            {/* ROLES */}

            <ImpactSection
              eyebrow="ROLE IMPACT"
              title="Roles affected"
              count={
                cascadeRoleCount
              }
            >

              {impactedRoles.length === 0 ? (

                <div className="empty-inline">
                  No role impact relationships
                  returned.
                </div>

              ) : (

                <div className="impact-grid">

                  {(showAllRoles
                    ? impactedRoles
                    : impactedRoles.slice(
                        0,
                        6
                      )
                  ).map(
                    (record, index) => {

                      const role =
                        record?.affected_role ||
                        findRole(
                          record.affected_role_id
                        );

                      return (

                        <ImpactCard
                          key={
                            record.cascade_id ||
                            `role-${index}`
                          }
                          type="ROLE"
                          title={
                            role?.name ||
                            `Role #${record.affected_role_id}`
                          }
                          subtitle={
                            role?.seniority_level ||
                            role?.role_code ||
                            ""
                          }
                          score={
                            record.impact_score
                          }
                        />

                      );
                    }
                  )}

                </div>

              )}

              {impactedRoles.length > 6 && (

                <button
                  className="text-button"
                  onClick={() =>
                    setShowAllRoles(
                      !showAllRoles
                    )
                  }
                >
                  {showAllRoles
                    ? "Show fewer roles"
                    : `View all ${impactedRoles.length} roles →`}
                </button>

              )}

            </ImpactSection>

            {/* SKILLS */}

            <ImpactSection
              eyebrow="CAPABILITY IMPACT"
              title="Skills affected"
              count={
                cascadeSkillCount
              }
            >

              {impactedSkills.length === 0 ? (

                <div className="empty-inline">
                  No skill impact relationships
                  returned.
                </div>

              ) : (

                <div className="impact-grid">

                  {(showAllSkills
                    ? impactedSkills
                    : impactedSkills.slice(
                        0,
                        6
                      )
                  ).map(
                    (record, index) => {

                      const skill =
                        findSkill(
                          record.affected_skill_id
                        );

                      return (

                        <ImpactCard
                          key={
                            record.cascade_id ||
                            `skill-${index}`
                          }
                          type="SKILL"
                          title={
                            skill?.name ||
                            `Skill #${record.affected_skill_id}`
                          }
                          subtitle={
                            skill?.category ||
                            skill?.skill_type ||
                            ""
                          }
                          score={
                            record.impact_score
                          }
                        />

                      );
                    }
                  )}

                </div>

              )}

              {impactedSkills.length > 6 && (

                <button
                  className="text-button"
                  onClick={() =>
                    setShowAllSkills(
                      !showAllSkills
                    )
                  }
                >
                  {showAllSkills
                    ? "Show fewer skills"
                    : `View all ${impactedSkills.length} skills →`}
                </button>

              )}

            </ImpactSection>

            {/* SECONDARY ACTIVITIES */}

            <ImpactSection
              eyebrow="SECONDARY IMPACT"
              title="Related activities"
              count={
                cascadeSummary.level_2_count ||
                impactedActivities.length
              }
            >

              {impactedActivities.length === 0 ? (

                <div className="empty-inline">
                  No secondary activity relationships
                  returned.
                </div>

              ) : (

                <div className="impact-grid">

                  {(showAllActivities
                    ? impactedActivities
                    : impactedActivities.slice(
                        0,
                        6
                      )
                  ).map(
                    (record, index) => (

                      <ImpactCard
                        key={
                          record.cascade_id ||
                          `activity-${index}`
                        }
                        type="ACTIVITY"
                        title={
                          record.activity?.name ||
                          `Activity #${record.affected_activity_id}`
                        }
                        subtitle={
                          record.activity?.activity_type ||
                          `Impact level ${record.impact_level || "—"}`
                        }
                        score={
                          record.impact_score
                        }
                      />

                    )
                  )}

                </div>

              )}

              {impactedActivities.length > 6 && (

                <button
                  className="text-button"
                  onClick={() =>
                    setShowAllActivities(
                      !showAllActivities
                    )
                  }
                >
                  {showAllActivities
                    ? "Show fewer activities"
                    : `View all ${impactedActivities.length} activities →`}
                </button>

              )}

            </ImpactSection>

            {/* FUTURE ROLES */}

            <ImpactSection
              eyebrow="FUTURE WORKFORCE"
              title="Future roles"
              count={
                Math.max(
                  Number(
                    cascadeSummary.level_4_count || 0
                  ),
                  futureRoles.length
                )
              }
            >

              {futureRoles.length === 0 ? (

                <div className="empty-inline">
                  No future-role cascade records
                  returned.
                </div>

              ) : (

                <div className="impact-grid">

                  {(showAllFutureRoles
                    ? futureRoles
                    : futureRoles.slice(
                        0,
                        6
                      )
                  ).map(
                    (record, index) => (

                      <ImpactCard
                        key={
                          record.cascade_id ||
                          `future-role-${index}`
                        }
                        type="FUTURE ROLE"
                        title={
                          record.role?.name ||
                          record.name ||
                          `Role #${record.affected_role_id || "—"}`
                        }
                        subtitle={
                          record.reasoning ||
                          "Future workforce impact"
                        }
                        score={
                          record.impact_score
                        }
                      />

                    )
                  )}

                </div>

              )}

              {futureRoles.length > 6 && (

                <button
                  className="text-button"
                  onClick={() =>
                    setShowAllFutureRoles(
                      !showAllFutureRoles
                    )
                  }
                >
                  {showAllFutureRoles
                    ? "Show fewer roles"
                    : `View all ${futureRoles.length} future roles →`}
                </button>

              )}

            </ImpactSection>

            {/* FUTURE SKILLS */}

            <ImpactSection
              eyebrow="FUTURE CAPABILITIES"
              title="Future skills"
              count={
                Math.max(
                  Number(
                    cascadeSummary.level_5_count || 0
                  ),
                  futureSkills.length
                )
              }
            >

              {futureSkills.length === 0 ? (

                <div className="empty-inline">
                  No future-skill cascade records
                  returned.
                </div>

              ) : (

                <div className="impact-grid">

                  {(showAllFutureSkills
                    ? futureSkills
                    : futureSkills.slice(
                        0,
                        6
                      )
                  ).map(
                    (record, index) => (

                      <ImpactCard
                        key={
                          record.cascade_id ||
                          `future-skill-${index}`
                        }
                        type="FUTURE SKILL"
                        title={
                          record.skill?.name ||
                          record.name ||
                          `Skill #${record.affected_skill_id || "—"}`
                        }
                        subtitle={
                          record.reasoning ||
                          "Future capability impact"
                        }
                        score={
                          record.impact_score
                        }
                      />

                    )
                  )}

                </div>

              )}

              {futureSkills.length > 6 && (

                <button
                  className="text-button"
                  onClick={() =>
                    setShowAllFutureSkills(
                      !showAllFutureSkills
                    )
                  }
                >
                  {showAllFutureSkills
                    ? "Show fewer skills"
                    : `View all ${futureSkills.length} future skills →`}
                </button>

              )}

            </ImpactSection>

          </section>

        )}

        {/* ====================================================
            SURPRISE RECORD
        ==================================================== */}

        <section className="panel surprise">

          <div className="surprise-top">

            <div>

              <span className="eyebrow">
                05 · SURPRISE RECORD TEST
              </span>

              <h2>
                Challenge the intelligence layer
              </h2>

              <p>
                Introduce a new activity the system
                has never seen and observe the complete
                runtime pipeline.
              </p>

            </div>

            <button
              className="primary-button"
              onClick={() =>
                setShowSurprise(
                  !showSurprise
                )
              }
            >
              {showSurprise
                ? "Close"
                : "+ New Activity"}
            </button>

          </div>

          {showSurprise && (

            <form
              className="surprise-form"
              onSubmit={
                submitSurprise
              }
            >

              <div className="form-row">

                <div className="field">

                  <label>
                    PROCESS
                  </label>

                  <select
                    value={
                      newActivity.process_id
                    }
                    onChange={(event) =>
                      setNewActivity(
                        (current) => ({
                          ...current,
                          process_id:
                            event.target.value,
                        })
                      )
                    }
                    required
                  >

                    <option value="">
                      Select process
                    </option>

                    {processes.map(
                      (process) => (

                        <option
                          key={
                            process.process_id
                          }
                          value={
                            process.process_id
                          }
                        >
                          {process.name}
                        </option>

                      )
                    )}

                  </select>

                </div>

                <div className="field">

                  <label>
                    ACTIVITY TYPE
                  </label>

                  <input
                    value={
                      newActivity.activity_type
                    }
                    onChange={(event) =>
                      setNewActivity(
                        (current) => ({
                          ...current,
                          activity_type:
                            event.target.value,
                        })
                      )
                    }
                    placeholder="ANALYSIS"
                  />

                </div>

              </div>

              <div className="field">

                <label>
                  ACTIVITY NAME
                </label>

                <input
                  value={
                    newActivity.name
                  }
                  onChange={(event) =>
                    setNewActivity(
                      (current) => ({
                        ...current,
                        name:
                          event.target.value,
                      })
                    )
                  }
                  placeholder="Enter a new enterprise activity..."
                  required
                />

              </div>

              <div className="field">

                <label>
                  DESCRIPTION
                </label>

                <textarea
                  rows="4"
                  value={
                    newActivity.description
                  }
                  onChange={(event) =>
                    setNewActivity(
                      (current) => ({
                        ...current,
                        description:
                          event.target.value,
                      })
                    )
                  }
                  placeholder="Describe what happens in this activity..."
                />

              </div>

              <div className="pipeline-preview">

                <span>
                  INGEST
                </span>

                <b>→</b>

                <span>
                  CLASSIFY
                </span>

                <b>→</b>

                <span>
                  AI ANALYZE
                </span>

                <b>→</b>

                <span>
                  LLAMA
                </span>

                <b>→</b>

                <span>
                  IMPACT
                </span>

              </div>

              <button
                className="primary-button"
                type="submit"
                disabled={
                  ingestionLoading
                }
              >
                {ingestionLoading
                  ? "Running Intelligence Pipeline..."
                  : "Run Surprise Record →"}
              </button>

            </form>

          )}

          {ingestionResult && (

            <div className="success-panel">

              <div className="success-icon">
                ✓
              </div>

              <div>

                <span className="eyebrow">
                  PIPELINE COMPLETE
                </span>

                <h3>
                  {
                    ingestionResult
                      ?.activity?.name
                  }
                </h3>

                <p>
                  Activity successfully ingested
                  and sent through the runtime
                  intelligence pipeline.
                </p>

              </div>

              <div className="success-steps">

                <span>✓ Ingested</span>
                <span>✓ Classified</span>
                <span>✓ AI analyzed</span>
                <span>✓ Llama</span>
                <span>✓ Cascade</span>

              </div>

            </div>

          )}

        </section>

      </main>

      {/* ======================================================
          FOOTER
      ====================================================== */}

      <footer>

        <div>
          <strong>
            NovaCart AI
          </strong>

          <span>
            Enterprise Workforce Intelligence
          </span>
        </div>

        <span>
          FastAPI · PostgreSQL · Ollama · Llama 3.2
        </span>

      </footer>

    </div>
  );
}


// ============================================================
// COMPONENTS
// ============================================================

function ReasoningCard({
  title,
  text,
  wide = false,
  confidence = false,
}) {
  return (
    <div
      className={
        wide
          ? "reasoning-card-item wide"
          : "reasoning-card-item"
      }
    >

      <span>
        {title}
      </span>

      <p
        className={
          confidence
            ? "reasoning-confidence"
            : ""
        }
      >
        {text ||
          "No reasoning returned."}
      </p>

    </div>
  );
}


function ImpactMetric({
  label,
  value,
}) {
  return (
    <div className="impact-metric">

      <span>
        {label}
      </span>

      <strong>
        {value}
      </strong>

    </div>
  );
}


function CascadeNode({
  number,
  label,
  title,
}) {
  return (
    <div className="cascade-node">

      <span className="cascade-number">
        {number}
      </span>

      <span className="cascade-label">
        {label}
      </span>

      <strong>
        {title}
      </strong>

    </div>
  );
}


function CascadeArrow() {
  return (
    <div className="cascade-arrow">
      →
    </div>
  );
}


function ImpactSection({
  eyebrow,
  title,
  count,
  children,
}) {
  return (
    <div className="impact-section">

      <div className="impact-section-header">

        <div>

          <span className="eyebrow">
            {eyebrow}
          </span>

          <h3>
            {title}
          </h3>

        </div>

        <span className="count-pill">
          {count}
        </span>

      </div>

      {children}

    </div>
  );
}


function ImpactCard({
  type,
  title,
  subtitle,
  score: impactScore,
}) {
  return (
    <div className="impact-card">

      <div className="impact-card-main">

        <span className="impact-type">
          {type}
        </span>

        <h4>
          {title}
        </h4>

        <small>
          {subtitle}
        </small>

      </div>

      <div
        className={`impact-percentage ${impactClass(
          impactScore
        )}`}
      >
        {impactScore !== undefined &&
        impactScore !== null
          ? `${Math.round(
              Number(impactScore)
            )}%`
          : "—"}
      </div>

    </div>
  );
}


function impactClass(value) {
  const n = Number(value || 0);

  if (n >= 75) {
    return "high";
  }

  if (n >= 50) {
    return "medium";
  }

  return "low";
}


function roleCountLabel(summary) {
  return Number(
    summary?.level_2_count || 0
  );
}


function skillCountLabel(summary) {
  return Number(
    summary?.level_3_count || 0
  );
}

export default App;