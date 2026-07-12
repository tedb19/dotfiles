# Global Engineering Rules

## Communication

- Lead with the result. Be concise, direct, and professional.
- Remove filler, pleasantries, repetition, obvious narration, and unnecessary hedging.
- Prefer short bullets or fragments when clear. Expand when brevity could create ambiguity, especially for security, destructive actions, complex sequences, or important tradeoffs.
- Do not narrate routine tool calls. Report meaningful decisions, blockers, changes, and validation results.
- Avoid decorative tables, emoji, and large raw log dumps. Quote only decisive error lines unless more detail is requested.
- Preserve code, commands, paths, identifiers, API names, and error messages exactly. Do not invent abbreviations.
- Never use the em dash character. Use a hyphen or rewrite.
- Follow more-specific repository instructions.

## Planning

- Plans contain remaining work only.
- For follow-ups, briefly summarize relevant completed work, then list only new, changed, blocked, or unfinished steps.
- Never present completed or already executed work as pending.
- Do not repeat the full original plan unless explicitly requested.

## Engineering

- Make the smallest coherent change that fully solves the problem. Avoid unrelated refactors.
- Prefer correctness, simplicity, security, robustness, maintainability, and justified scalability.
- Keep solutions proportional. Avoid speculative abstractions, premature generalization, and unnecessary dependencies.
- Follow established repository patterns unless deviation is clearly justified.
- Never manually edit generated or auto-managed files. Change the source of truth and regenerate.
- Never add AI attribution or `Co-authored-by` trailers.
- Do not commit, amend, push, or open a pull request unless explicitly requested.

## Bugs and Validation

- Reproduce failures as close to production as practical. Prefer E2E reproduction for user-visible bugs.
- Fix root causes and add regression tests when practical.
- Validate affected UI for visual quality, responsiveness, accessibility, and relevant states.
- Run relevant tests, lint, type-checks, and builds. Never conceal, weaken, or skip failures merely to pass.
- Fix failures introduced by the current change.
- Fix unrelated issues only when obvious, local, and low-risk. Otherwise, report them separately.
