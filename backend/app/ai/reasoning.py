from __future__ import annotations

import json
from typing import Any

import requests


class LlamaReasoner:
    """
    Local LLM reasoning layer using Ollama + Llama 3.2.

    PostgreSQL provides verified enterprise facts.
    Llama provides reasoning and explanations.
    """

    OLLAMA_URL = "http://localhost:11434/api/generate"
    MODEL = "llama3.2:latest"

    @classmethod
    def reason(
        cls,
        activity: dict[str, Any],
        classification: dict[str, Any],
        analysis: dict[str, Any],
        roles: list[dict[str, Any]] | None = None,
        skills: list[dict[str, Any]] | None = None,
        cascade_summary: dict[str, Any] | None = None,
    ) -> dict[str, Any]:

        roles = roles or []
        skills = skills or []
        cascade_summary = cascade_summary or {}

        context = {
            "activity": activity,
            "classification": classification,
            "ai_assessment": analysis,
            "roles": roles,
            "skills": skills,
            "cascade_summary": cascade_summary,
        }

        prompt = f"""
You are the enterprise AI reasoning engine for NovaCart AI.

Your task is to analyze the impact of AI on ONE enterprise activity.

IMPORTANT RULES:

1. Use ONLY the information provided in the context.
2. Do not invent roles, skills, activities, technologies, or relationships.
3. Treat PostgreSQL data as the source of truth.
4. Explain the reasoning clearly for an enterprise decision-maker.
5. Distinguish automation from augmentation.
6. Physical work should not automatically be described as fully automatable.
7. Identify what humans should continue doing when appropriate.
8. Return ONLY valid JSON.
9. Do not use markdown.
10. Do not include text outside the JSON object.

Return exactly this structure:

{{
  "summary": "Short executive explanation",
  "automation_reasoning": "Why AI can or cannot automate this activity",
  "augmentation_reasoning": "How AI can assist the human worker",
  "human_role": "What humans should continue doing",
  "skill_change": "How required skills may change",
  "future_outlook": "Expected future-state change",
  "confidence": 0.0
}}

Enterprise context:

{json.dumps(context, indent=2, default=str)}
"""

        try:
            response = requests.post(
                cls.OLLAMA_URL,
                json={
                    "model": cls.MODEL,
                    "prompt": prompt,
                    "stream": False,
                    "format": "json",
                    "options": {
                        "temperature": 0.2,
                    },
                },
                timeout=120,
            )

            response.raise_for_status()

            data = response.json()

            raw_response = data.get(
                "response",
                "",
            ).strip()

            if not raw_response:
                raise ValueError(
                    "Ollama returned an empty response"
                )

            reasoning = json.loads(
                raw_response
            )

            return {
                "provider": "ollama",
                "model": cls.MODEL,
                "status": "success",
                "reasoning": reasoning,
            }

        except requests.exceptions.ConnectionError:

            return {
                "provider": "ollama",
                "model": cls.MODEL,
                "status": "error",
                "error": (
                    "Could not connect to Ollama. "
                    "Make sure Ollama is running."
                ),
            }

        except requests.exceptions.Timeout:

            return {
                "provider": "ollama",
                "model": cls.MODEL,
                "status": "error",
                "error": (
                    "Ollama request timed out."
                ),
            }

        except json.JSONDecodeError:

            return {
                "provider": "ollama",
                "model": cls.MODEL,
                "status": "error",
                "error": (
                    "Llama returned invalid JSON."
                ),
            }

        except requests.exceptions.RequestException as exc:

            return {
                "provider": "ollama",
                "model": cls.MODEL,
                "status": "error",
                "error": str(exc),
            }

        except Exception as exc:

            return {
                "provider": "ollama",
                "model": cls.MODEL,
                "status": "error",
                "error": str(exc),
            }