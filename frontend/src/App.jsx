import { useEffect, useState } from "react";
import "./App.css";

const API_BASE = "http://127.0.0.1:8000";

async function apiFetch(path, options = {}) {
  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: {
      Accept: "application/json",
      ...(options.headers || {}),
    },
  });

  if (!response.ok) {
    let detail = "";

    try {
      const body = await response.json();
      detail = body.detail || body.error || "";
    } catch {
      // Ignore non-JSON error responses.
    }

    throw new Error(
      detail || `Request failed (${response.status})`
    );
  }

  return response.json();
}

function App() {
  const [industries, setIndustries] = useState([]);
  const [valueChains, setValueChains] = useState([]);
  const [processes, setProcesses] = useState([]);
  const [activities, setActivities] = useState([]);
  const [roles, setRoles] = useState([]);

  const [selectedIndustry, setSelectedIndustry] = useState("");
  const [selectedValueChain, setSelectedValueChain] = useState("");
  const [selectedProcess, setSelectedProcess] = useState("");
  const [selectedActivity, setSelectedActivity] = useState("");

  const [aiAnalysis, setAiAnalysis] = useState(null);
  const [reasoning, setReasoning] = useState(null);
  const [cascade, setCascade] = useState(null);

  const [loading, setLoading] = useState(false);
  const [aiLoading, setAiLoading] = useState(false);
  const [error, setError] = useState("");

  // ============================================================
  // LOAD INDUSTRIES
  // ============================================================

  useEffect(() => {
    async function loadIndustries() {
      try {
        setError("");

        const data = await apiFetch("/api/industries");

        setIndustries(
          Array.isArray(data) ? data : []
        );
      } catch (err) {
        setError(
          `Failed to load industries: ${err.message}`
        );
      }
    }

    loadIndustries();
  }, []);

  // ============================================================
  // INDUSTRY → VALUE CHAINS
  // ============================================================

  async function handleIndustryChange(industryId) {
    setSelectedIndustry(industryId);

    setSelectedValueChain("");
    setSelectedProcess("");
    setSelectedActivity("");

    setValueChains([]);
    setProcesses([]);
    setActivities([]);
    setRoles([]);

    setAiAnalysis(null);
    setReasoning(null);
    setCascade(null);
    setError("");

    if (!industryId) {
      return;
    }

    try {
      setLoading(true);

      const data = await apiFetch(
        `/api/industries/${Number(industryId)}/value-chains`
      );

      setValueChains(
        Array.isArray(data) ? data : []
      );
    } catch (err) {
      setError(
        `Failed to load value chains: ${err.message}`
      );
    } finally {
      setLoading(false);
    }
  }

  // ============================================================
  // VALUE CHAIN → PROCESSES
  // ============================================================

  async function handleValueChainChange(valueChainId) {
    setSelectedValueChain(valueChainId);

    setSelectedProcess("");
    setSelectedActivity("");

    setProcesses([]);
    setActivities([]);
    setRoles([]);

    setAiAnalysis(null);
    setReasoning(null);
    setCascade(null);
    setError("");

    if (!valueChainId) {
      return;
    }

    try {
      setLoading(true);

      console.log(
        "Loading processes for value chain:",
        valueChainId
      );

      const data = await apiFetch(
        `/api/value-chains/${Number(valueChainId)}/processes`
      );

      console.log(
        "Processes received:",
        data
      );

      setProcesses(
        Array.isArray(data) ? data : []
      );
    } catch (err) {
      console.error(
        "Process loading error:",
        err
      );

      setError(
        `Failed to load processes: ${err.message}`
      );
    } finally {
      setLoading(false);
    }
  }

  // ============================================================
  // PROCESS → ACTIVITIES + ROLES
  // ============================================================

  async function handleProcessChange(processId) {
    setSelectedProcess(processId);
    setSelectedActivity("");

    setActivities([]);
    setRoles([]);

    setAiAnalysis(null);
    setReasoning(null);
    setCascade(null);
    setError("");

    if (!processId) {
      return;
    }

    try {
      setLoading(true);

      const [
        activitiesData,
        rolesData,
      ] = await Promise.all([
        apiFetch(
          `/api/processes/${Number(processId)}/activities`
        ),
        apiFetch(
          `/api/processes/${Number(processId)}/roles`
        ),
      ]);

      setActivities(
        Array.isArray(activitiesData)
          ? activitiesData
          : []
      );

      setRoles(
        Array.isArray(rolesData)
          ? rolesData
          : []
      );
    } catch (err) {
      setError(
        `Failed to load process data: ${err.message}`
      );
    } finally {
      setLoading(false);
    }
  }

  // ============================================================
  // ACTIVITY → AI ANALYSIS
  // ============================================================

  async function handleActivityChange(activityId) {
    setSelectedActivity(activityId);

    setAiAnalysis(null);
    setReasoning(null);
    setCascade(null);
    setError("");

    if (!activityId) {
      return;
    }

    try {
      setLoading(true);

      const data = await apiFetch(
        `/api/ai-analysis/activities/${Number(activityId)}`
      );

      setAiAnalysis(data);
    } catch (err) {
      setError(
        `Failed to load AI analysis: ${err.message}`
      );
    } finally {
      setLoading(false);
    }
  }

  // ============================================================
  // LLAMA 3.2 REASONING
  // ============================================================

  async function analyzeWithAI() {
    if (!selectedActivity) {
      return;
    }

    try {
      setAiLoading(true);
      setError("");

      const data = await apiFetch(
        `/api/ai-analysis/activities/${Number(
          selectedActivity
        )}/reason`,
        {
          method: "POST",
        }
      );

      setReasoning(data);
    } catch (err) {
      setError(
        `Failed to run AI reasoning: ${err.message}`
      );
    } finally {
      setAiLoading(false);
    }
  }

  // ============================================================
  // IMPACT CASCADE
  // ============================================================

  async function loadCascade() {
    if (!selectedActivity) {
      return;
    }

    try {
      setLoading(true);
      setError("");

      const data = await apiFetch(
        `/api/ai-analysis/activities/${Number(
          selectedActivity
        )}/cascade`
      );

      setCascade(data);
    } catch (err) {
      setError(
        `Failed to load impact cascade: ${err.message}`
      );
    } finally {
      setLoading(false);
    }
  }

  // ============================================================
  // SELECTED ACTIVITY
  // ============================================================

  const selectedActivityData =
    activities.find(
      (activity) =>
        String(activity.activity_id) ===
        String(selectedActivity)
    );

  // ============================================================
  // RENDER
  // ============================================================

  return (
    <div className="app-shell">

      {/* ======================================================
          HEADER
      ====================================================== */}

      <header className="topbar">

        <div>
          <div className="brand">
            NovaCart <span>AI</span>
          </div>

          <div className="subtitle">
            Enterprise AI Workforce Intelligence
          </div>
        </div>

        <div className="status">
          <span className="status-dot"></span>
          Llama 3.2 · Local AI
        </div>

      </header>


      {/* ======================================================
          HERO
      ====================================================== */}

      <section className="hero-section">

        <div className="eyebrow">
          AI IMPACT INTELLIGENCE PLATFORM
        </div>

        <h1>
          Understand how AI transforms
          <span> enterprise work.</span>
        </h1>

        <p>
          Explore business processes, activities,
          roles, skills and cascading AI impacts
          through a connected intelligence graph.
        </p>

      </section>


      {/* ======================================================
          ERROR
      ====================================================== */}

      {error && (
        <div className="error-box">

          <strong>
            Something went wrong
          </strong>

          <span>
            {error}
          </span>

          <button
            type="button"
            onClick={() => setError("")}
          >
            ×
          </button>

        </div>
      )}


      {/* ======================================================
          GRAPH EXPLORER
      ====================================================== */}

      <section className="explorer-card">

        <div className="section-heading">

          <div>

            <div className="section-label">
              GRAPH EXPLORER
            </div>

            <h2>
              Navigate the enterprise graph
            </h2>

          </div>

          {loading && (
            <div className="loader">
              Loading...
            </div>
          )}

        </div>


        <div className="selector-grid">

          {/* INDUSTRY */}

          <div className="selector">

            <label>
              01 · Industry
            </label>

            <select
              value={selectedIndustry}
              onChange={(event) =>
                handleIndustryChange(
                  event.target.value
                )
              }
            >

              <option value="">
                Select industry
              </option>

              {industries.map((industry) => (

                <option
                  key={industry.industry_id}
                  value={industry.industry_id}
                >
                  {industry.name}
                </option>

              ))}

            </select>

          </div>


          {/* VALUE CHAIN */}

          <div className="selector">

            <label>
              02 · Value Chain
            </label>

            <select
              value={selectedValueChain}
              onChange={(event) =>
                handleValueChainChange(
                  event.target.value
                )
              }
              disabled={!selectedIndustry}
            >

              <option value="">
                Select value chain
              </option>

              {valueChains.map((chain) => (

                <option
                  key={chain.value_chain_id}
                  value={chain.value_chain_id}
                >
                  {chain.name}
                </option>

              ))}

            </select>

          </div>


          {/* PROCESS */}

          <div className="selector">

            <label>
              03 · Process
            </label>

            <select
              value={selectedProcess}
              onChange={(event) =>
                handleProcessChange(
                  event.target.value
                )
              }
              disabled={!selectedValueChain}
            >

              <option value="">
                Select process
              </option>

              {processes.map((process) => (

                <option
                  key={process.process_id}
                  value={process.process_id}
                >
                  {process.name}
                </option>

              ))}

            </select>

          </div>


          {/* ACTIVITY */}

          <div className="selector">

            <label>
              04 · Activity
            </label>

            <select
              value={selectedActivity}
              onChange={(event) =>
                handleActivityChange(
                  event.target.value
                )
              }
              disabled={!selectedProcess}
            >

              <option value="">
                Select activity
              </option>

              {activities.map((activity) => (

                <option
                  key={activity.activity_id}
                  value={activity.activity_id}
                >
                  {activity.name}
                </option>

              ))}

            </select>

          </div>

        </div>


        {/* ====================================================
            ROLES
        ==================================================== */}

        {roles.length > 0 && (

          <div className="context-section">

            <div className="context-title">
              Roles involved
            </div>

            <div className="tag-list">

              {roles.map((role) => (

                <div
                  className="tag"
                  key={role.role_id}
                >
                  {role.name}
                </div>

              ))}

            </div>

          </div>

        )}

      </section>


      {/* ======================================================
          AI INTELLIGENCE
      ====================================================== */}

      {selectedActivityData && (

        <section className="intelligence-grid">

          {/* ACTIVITY */}

          <div className="activity-card">

            <div className="section-label">
              SELECTED ACTIVITY
            </div>

            <h2>
              {selectedActivityData.name}
            </h2>

            <p>
              {selectedActivityData.description}
            </p>

            <div className="activity-meta">

              <span>
                {selectedActivityData.activity_type}
              </span>

              <span>
                ID #{selectedActivityData.activity_id}
              </span>

            </div>

          </div>


          {/* AI OPPORTUNITIES */}

          {aiAnalysis?.ai_opportunities?.map(
            (opportunity) => (

              <div
                className="opportunity-card"
                key={
                  opportunity.ai_opportunity_id
                }
              >

                <div className="section-label">
                  AI OPPORTUNITY
                </div>

                <h3>
                  {opportunity.name}
                </h3>

                <p>
                  {opportunity.description}
                </p>

                <div className="score-grid">

                  <Score
                    label="Automation"
                    value={
                      opportunity.automation_score
                    }
                  />

                  <Score
                    label="Augmentation"
                    value={
                      opportunity.augmentation_score
                    }
                  />

                  <Score
                    label="Confidence"
                    value={
                      opportunity.confidence_score
                    }
                  />

                </div>

                <div className="technology">
                  {opportunity.technology}
                </div>

              </div>

            )
          )}

        </section>

      )}


      {/* ======================================================
          AI ACTIONS
      ====================================================== */}

      {selectedActivity && (

        <section className="actions-section">

          <button
            type="button"
            className="primary-button"
            onClick={analyzeWithAI}
            disabled={aiLoading}
          >
            {aiLoading
              ? "Llama is reasoning..."
              : "✦ Analyze with AI"}
          </button>

          <button
            type="button"
            className="secondary-button"
            onClick={loadCascade}
            disabled={loading}
          >
            View Impact Cascade
          </button>

        </section>

      )}


      {/* ======================================================
          LLM REASONING
      ====================================================== */}

      {reasoning?.llm_reasoning?.status ===
        "success" && (

        <section className="reasoning-card">

          <div className="reasoning-header">

            <div>

              <div className="section-label">
                RUNTIME AI REASONING
              </div>

              <h2>
                Llama 3.2 Analysis
              </h2>

            </div>

            <div className="model-badge">
              ● Ollama · llama3.2:latest
            </div>

          </div>


          <div className="reasoning-summary">

            {
              reasoning.llm_reasoning
                .reasoning.summary
            }

          </div>


          <div className="reasoning-grid">

            <ReasoningBlock
              title="Automation"
              text={
                reasoning.llm_reasoning
                  .reasoning
                  .automation_reasoning
              }
            />

            <ReasoningBlock
              title="Augmentation"
              text={
                reasoning.llm_reasoning
                  .reasoning
                  .augmentation_reasoning
              }
            />

            <ReasoningBlock
              title="Human Role"
              text={
                reasoning.llm_reasoning
                  .reasoning
                  .human_role
              }
            />

            <ReasoningBlock
              title="Skill Change"
              text={
                reasoning.llm_reasoning
                  .reasoning
                  .skill_change
              }
            />

          </div>


          <div className="future-box">

            <strong>
              Future outlook
            </strong>

            <p>
              {
                reasoning.llm_reasoning
                  .reasoning
                  .future_outlook
              }
            </p>

          </div>

        </section>

      )}


      {/* ======================================================
          IMPACT CASCADE
      ====================================================== */}

      {cascade && (

        <section className="cascade-card">

          <div className="section-heading">

            <div>

              <div className="section-label">
                AI IMPACT CASCADE
              </div>

              <h2>
                How the impact propagates
              </h2>

            </div>

            <div className="cascade-total">
              {cascade.summary?.total_cascade_records ??
                0}{" "}
              records
            </div>

          </div>


          <div className="cascade-levels">

            <CascadeLevel
              number="01"
              title="Direct Impact"
              items={
                cascade.cascade?.level_1_direct ||
                []
              }
            />

            <CascadeLevel
              number="02"
              title="Role / Activity"
              items={
                cascade.cascade?.level_2_role_activity ||
                []
              }
            />

            <CascadeLevel
              number="03"
              title="Skills"
              items={
                cascade.cascade?.level_3_skill ||
                []
              }
            />

            <CascadeLevel
              number="04"
              title="Future Roles"
              items={
                cascade.cascade?.level_4_future_role ||
                []
              }
            />

            <CascadeLevel
              number="05"
              title="Future Skills"
              items={
                cascade.cascade?.level_5_future_skill ||
                []
              }
            />

          </div>

        </section>

      )}


      <footer>
        NovaCart AI · Enterprise Workforce Intelligence
      </footer>

    </div>
  );
}


// ============================================================
// SCORE
// ============================================================

function Score({ label, value }) {
  return (
    <div className="score">

      <span>
        {label}
      </span>

      <strong>
        {value ?? "—"}%
      </strong>

    </div>
  );
}


// ============================================================
// REASONING BLOCK
// ============================================================

function ReasoningBlock({ title, text }) {
  return (
    <div className="reasoning-block">

      <h3>
        {title}
      </h3>

      <p>
        {text || "No reasoning available."}
      </p>

    </div>
  );
}


// ============================================================
// CASCADE LEVEL
// ============================================================

function CascadeLevel({
  number,
  title,
  items = [],
}) {
  const visibleItems = items.slice(0, 8);

  return (
    <div className="cascade-level">

      <div className="level-number">
        {number}
      </div>

      <div className="level-content">

        <h3>
          {title}
        </h3>

        <span className="level-count">
          {items.length} impacts
        </span>

        <div className="cascade-items">

          {visibleItems.map((item) => {

            const entity =
              item.affected_role ||
              item.affected_skill ||
              item.affected_activity;

            if (!entity) {
              return null;
            }

            return (
              <div
                className="cascade-item"
                key={item.cascade_id}
              >

                <strong>
                  {entity.name}
                </strong>

                {item.impact_score != null && (
                  <span>
                    {item.impact_score}%
                  </span>
                )}

              </div>
            );
          })}

        </div>

        {items.length > 8 && (
          <div className="more-items">
            + {items.length - 8} more impacts
          </div>
        )}

      </div>

    </div>
  );
}


export default App;