# AGENTS.md — start here (adlc-demo)

Demo monorepo (.NET 8 API + React/Vite frontend) delivered by the adlc plugin

This repository is delivered by the **adlc** Claude Code plugin (0.10.1). This file is the routing page for humans and agents: what is here, which skill to run, which rules apply. Procedures live in the plugin's skills, not here.

## Layout
| App | Path | Kind | Stack | Port | Health |
|---|---|---|---|---|---|
| `api` | `apps/api` | api | dotnet8-api | 8080 | `/health` |
| `web` | `apps/web` | frontend | react-vite | 8080 | `/` |


| Path | Purpose |
|---|---|
| `.adlc/config.yaml` | Delivery options and app inventory (source of truth for every adlc skill) |
| `.adlc/SETUP.md`, `.adlc/setup-azure.sh` | One-time human prerequisites (checklist + idempotent script, dry run by default): GitHub secrets/variables, environment, Entra app registration with OIDC, state storage, RBAC |
| `.adlc/evidence/` | Verification records per deployed tag |
| `infra/foundation/` | Shared cloud resources (registry, key vault, identity, logs). Applied by a human after `/adlc:plan`; never by an agent alone |
| `infra/app/` | Compute for the apps + image tags. Applied only by the CD workflow behind the environment approval |
| `.github/workflows/ci.yml` | Build, test, version, push immutable image tags |
| `.github/workflows/cd.yml` | Deploy one immutable tag to one environment (`workflow_dispatch`) |
| `compose.yaml` | Local run of all app images as built for the cloud (frontends use `nginx.local.conf`) |
| `.claude/rules/` | Path-scoped rules (see Rules below) |

## Delivery options chosen
| Dimension | Option |
|---|---|
| cloud | `azure` — Microsoft Azure |
| compute | `aca` — Azure Container Apps |
| registry | `acr` — Azure Container Registry |
| runner | `github-actions` — GitHub Actions |
| versioning | `nbgv` — Nerdbank.GitVersioning |
| branching | `trunk` — Trunk-based (main + short-lived branches + PRs) |
| tracker | `jira` — Jira Cloud (Atlassian Rovo MCP Server; Standard plan or higher) |
| secret_store | `azure-key-vault` — Azure Key Vault |
| base_image | `dhi` — Docker Hardened Images (dhi.io |

Change an option with `/adlc:bootstrap`; do not edit generated files by hand to switch options.

## I want to…
| Goal | Run |
|---|---|
| Onboard or change delivery options | `/adlc:bootstrap` |
| Build and smoke-test one app image locally | `/adlc:dockerize <app path>` |
| Run every app image together locally | `VERSION=$(nbgv get-version -v SemVer2) docker compose up --build` (see `compose.yaml`) |
| See what infrastructure would change | `/adlc:plan <env> --layer foundation\|app` |
| Deploy a released tag | `/adlc:deploy <tag> <env>` |
| Prove a deployment is correct | `/adlc:verify <env> <tag>` |
| Track the work | `/adlc:ticket create\|start\|review\|done <key>` |
| Understand the repo before changing it | ask for the `explore` sub-agent |
| Make a scoped change with proof | ask for the `execute` sub-agent with an acceptance command |
| Check claims independently | ask for the `verify` sub-agent |

## Skills
<available_skills>
- adlc:bootstrap — intake interview, app classification, scaffold, ticket
- adlc:dockerize — hardened multi-stage Dockerfile for one app, built and health-checked
- adlc:plan — terraform fmt/validate/plan for one layer; never applies
- adlc:deploy — trigger and monitor CD for an immutable tag
- adlc:verify — falsifiable post-deploy checks; writes .adlc/evidence/<tag>.md
- adlc:ticket — tracker lifecycle with structured descriptions
- adlc:delivery-knowledge — option reference material (model-invoked)
</available_skills>
Skills come from the plugin (`adlc@adlc-marketplace`, source `integranz/adlc`), declared in `.claude/settings.json`. Local sessions install it once with `/plugin install adlc@adlc-marketplace`; cloud sessions install it automatically.

## Sub-agents
`explore` (read-only facts with `path:line` evidence), `execute` (one scoped change + acceptance output), `verify` (CONFIRMED / REFUTED / UNVERIFIABLE per claim). None of them may apply infrastructure, push images or trigger workflows; guard hooks enforce this.

## Systems of record and tool policy
| Need | Use | Not |
|---|---|---|
| Tickets | `/adlc:ticket` (tracker MCP: Jira Cloud (Atlassian Rovo MCP Server; Standard plan or higher)) | manual browser updates |
| Pipeline status, logs, trigger CD | GitHub MCP via `/adlc:deploy` / `/adlc:verify` | `gh` for writes |
| Cloud inventory for verification | Azure MCP (read-only) or `az … show/list` | Azure MCP for changes |
| Infrastructure changes | Terraform in `infra/*` under the guard hooks | portal, `az … create`, Azure MCP writes |
| Images | CI pushes `acradlcdemo.azurecr.io/<repo>:<semver>` | `docker push` from a laptop, `latest` tags |

## Rules and precedence
Non-negotiables are in `CLAUDE.md`. Path-scoped rules are in `.claude/rules/` and load only when matching files are touched: `terraform.md` (`infra/**`), `pipelines.md` (`.github/workflows/**`), `docker.md` (Dockerfiles), `versioning.md`, `branching.md`. Precedence when instructions overlap: managed policy → user (`~/.claude/CLAUDE.md`) → project (`CLAUDE.md`, `.claude/rules/`) → `CLAUDE.local.md`. Hooks from the plugin are mechanical and cannot be relaxed by any of these; see `.claude/rules/precedence.md`.

## Multi-repo
Open **this repo alone** as the workspace root when working on the apps or their delivery. The plugin repo (`integranz/adlc`) owns cross-cutting changes (templates, hooks, skills); propose changes there rather than patching generated files here. Keep one `.mcp.json`/MCP policy per repo: this repo relies on the plugin's servers and declares none of its own.

## Other agents
Cursor reads this file natively and loads skills from `.claude/skills/` when present; the adlc skills live in the plugin, so use Claude Code for adlc workflows unless a mirror is enabled (`cursor_mirror` in `.adlc/config.yaml`).
