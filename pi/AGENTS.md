# Global Instructions

## Context

Michal is on the **Hlidskjalf** (infrastructure/platform) team at Oddin. Primary focus: designing the Terragrunt-based module library and workload consumption patterns on AWS.

### Oddin Terraform Repos

- `terraform-infrastructure` — currently used Terragrunt monolith (one state per branch, manual `make` deploys). **Not a POC, not legacy** — do not characterize it as either. Correct framing: "Stacks are being migrated from `terraform-infrastructure` into `terraform-aws-workloads`."
- `terraform-modules` — versioned module library. Path-prefixed git tags (e.g. `aws/null/env_naming/v0.2.0`). Consumed via `git::ssh://…?ref=…`.
- `terraform-aws-workloads` — Terragrunt live repo for workload accounts. Thin wiring only — no reusable modules here.
- `terraform-aws-organization` — AWS Organizations, OUs, SCPs, account vending.
- `terraform-github` — GitHub org configuration (repos, teams, permissions).

## GitHub

Always use the `gh` CLI for any GitHub-related operations (issues, PRs, CI runs, API queries). Never use web scraping or raw API calls when `gh` can do it. Refer to the `github` skill for usage patterns.

## Jira

Always use the Atlassian CLI (`acli`) for any Jira-related operations (issues, boards, sprints, searches, or when a `oddingg.atlassian.net` URL is referenced). Never use web scraping or raw API calls when `acli` can do it. Refer to the `jira` skill for usage patterns and Context7 docs.

## Notion

Always use `notion-cli` for any Notion-related operations (searching KB pages, fetching content, editing pages, or when a `notion.so` URL is referenced). Never use web scraping or raw API calls when `notion-cli` can do it. Refer to the `notion` skill for usage patterns.

## Terraform / OpenTofu

When working with Terraform, OpenTofu, or HCL:
- Load the `terraform-skill` skill for best practices, module patterns, testing strategies, and code structure guidance.
- Use the `terraform-registry` skill to look up provider resource/data-source documentation and module details from the Terraform Registry. Always prefer this over guessing resource arguments or attributes.

## Code Quality

- **Formatting**: Always run the appropriate formatter before committing (`terraform fmt`, `gofmt`/`goimports`, `ruff format` for Python).
- **Linting**: Run linters when available (`tflint`, `trivy config .`, `golangci-lint run`, `ruff check`). Fix issues before committing.
- **Naming**: Use snake_case for Terraform resources/variables, snake_case for Python, camelCase for Go unexported / PascalCase for Go exported.
- **Comments**: Write comments that explain *why*, not *what*. Don't add obvious comments.

## Safety Guardrails

- Never run `terraform apply` or `terraform destroy` without explicit user confirmation.
- Never modify or delete files under `~/.ssh`, `~/.aws`, `~/.gnupg`.
- Before running destructive commands (`rm -rf`, `git reset --hard`, `git push --force`), explain what will happen and ask for confirmation.
- Never commit secrets, credentials, or `.env` files.

## Workflow Preferences

- **Commits**: Use the `commit` skill. Follow Conventional Commits format.
- **Branch names**: Use `<type>/<short-description>` (e.g., `feat/vpc-module`, `fix/s3-policy`).

## PR Bodies

- Each paragraph on one long unbroken line — GitHub renders single newlines as `<br>`, so hard-wrapped text looks fragmented.
- Describe what the change does, not the meta-story. No internal phase labels, no external inspiration name-drops, no "trimmed from MVP" framing.
- Point at canonical docs (roadmaps, READMEs) for context — don't re-narrate them.
- When referencing other Oddin repos, use neutral factual terms.

## PR Reviews

- Post inline comments on specific file lines (`gh api` with `path`, `line`, `body`), not general PR-level review body comments.
- Be direct — state suggestions as better practice: "X should be Y because Z". Don't hedge with "would you be open to" or "nit / non-blocking" softeners when the suggestion is genuinely worth acting on.
- Focus on security, correctness, and maintainability — in that order.

## Removals and Refactors

- When removing a concept (feature, command, enum value), `grep -ni '<concept>' <touched-files>` before committing. Catches stale descriptions, comments, echo strings, and docs referencing the removed concept.
- In workflow YAML: scan top block-comment, `name:`/`description:` on every input/job/step, and string bodies inside `run:` blocks.
- When adopting a parsing/formatting pattern from an external source, list the source's category→symbol mapping and decide which collapses you're keeping vs splitting. Document semantic intent of each symbol.

## Staged vs Deleted Work

- **Comment out in place** when: single file, expresses design/ownership intent, near-term unlock, clear status header.
- **Delete and capture in a roadmap doc** when: spans multiple files or longer horizon. Include Status, Why deferred, What unlocks it, How to enable.
- Exploratory dead ends that proved wrong — delete without a roadmap entry.

## Cloud (AWS)

- Default region is `eu-west-1` unless specified otherwise.
- Always use tags for resources: at minimum `Environment`, `Project`, `ManagedBy=terraform`.
- Prefer IAM roles over access keys. Use least-privilege policies.
- Use SSM Parameter Store or Secrets Manager for sensitive values — never hardcode.

## Language Preferences

- **Shell**: Prefer `bash` with `set -euo pipefail`. Use `shellcheck` conventions.
- **Python**: Target Python 3.11+. Use type hints. Prefer `pathlib` over `os.path`.
- **Go**: Follow standard project layout. Handle all errors — no `_` for error returns.
- **HCL**: Follow the `terraform-skill` conventions for block ordering and structure.

## Communication Style

- Be concise. Show the solution, not lengthy explanations.
- When multiple approaches exist, briefly list tradeoffs and recommend one.
- If uncertain about intent, ask before making changes.
