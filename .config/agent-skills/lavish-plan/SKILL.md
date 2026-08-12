---
name: lavish-plan
description: "Convergent visual review of a non-trivial technical plan, PRD, architecture change, migration, dependency set, or meaningful tradeoff via the lavish-axi CLI, when annotation or visual decisions aid review, or when explicitly requested. Not for brainstorming, simple or obvious plans, status updates, trivial fixes, or quick explanations."
---

# lavish-plan

Turn a drafted technical plan into a Lavish review surface for **convergent review**: visual
structure, inline annotation, and interactive decisions. `lavish-axi` is the tool; this skill is
the workflow around it.

## Position in the flow

`discuss/grill-me → investigate repo → draft plan/PRD → **lavish-plan** → annotate + decide →
approved plan → issues/slices → implement`

Convergent review of a drafted plan. Not brainstorming, not status, not divergence.

## Review loop

1. Write the artifact under `.lavish/` in the current project.
2. Open: `lavish-axi <file>`.
3. Poll for feedback (foreground): `lavish-axi poll <file>`. Leave it running.
4. Apply feedback to the **existing** artifact; poll again.
5. End cleanly when review is done: `lavish-axi end <file>`.

While the surface is active, keep terminal replies extremely terse; the artifact is the surface.

## Follow-up discipline (the point of this skill)

On each round of feedback, edit in place; do not regenerate or restate the plan:
- retain settled decisions;
- delete resolved questions and obsolete options;
- show only remaining work and open decisions;
- never accumulate conversational history in the artifact.

The artifact gets progressively **cleaner** as decisions land.

## Content

Include only sections that help this specific task, e.g. goal/outcome, relevant current state,
proposed approach, architecture/data-flow, key decisions, vertical slices, dependencies, risks/
failure modes, migration/compat, open questions, acceptance criteria. Never include all
mechanically. Optimize for scanning, deciding, and annotating: compact cards, short bullets,
diagrams, comparisons, decision controls. Not a prettier dump of a Markdown doc, not prose walls.

## Shape to the problem

Let the problem pick the structure: architecture → lead with a Mermaid diagram; migration →
current vs target + rollout phases; feature → vertical slices + dependencies; a decision →
side-by-side comparison with a concise interactive choice; UI → screenshot/mockup; security →
trust boundaries + risks. Use interactive input for a real unresolved decision, not every
question; text annotations stay first-class. Visual polish only where it aids comprehension.

## Cost discipline

High signal per token. Load a playbook only when it earns its place: `lavish-axi playbook plan`
for structure, `playbook diagram` for a needed diagram, `playbook comparison` for a real
decision, `playbook input` for structured choices. Don't combine playbooks reflexively. Defer
design-system/CDN specifics to `lavish-axi design`; defer other mechanics to `lavish-axi --help`.
Skip elaborate design investigation for a straightforward engineering review.

## Local & safe

Artifacts stay local. Never `lavish-axi share`/publish unless the user explicitly asks. Never put
secrets, credentials, production, customer, or regulated data in an artifact. Don't commit
`.lavish/` (globally git-ignored).
