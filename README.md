# GraspTech Salesforce DX Project

This repository contains Salesforce metadata for the GraspTech platform.
All development work is version-controlled using Git and follows a CI-based
validation approach before deployment to higher environments.

---

## Project Structure

force-app/main/default/ → Salesforce metadata (Apex, LWC, Flows, Config)
manifest/package.xml → Metadata retrieval / deployment control
scripts/ → Utility scripts (Apex / SOQL)
config/ → Scratch org / project config


---

##  Git Branch Strategy

| Branch | Purpose |
|------|--------|
| `sandbox` | Development / Integration branch |
| `main` | Production-ready code |
| `feature/*` | Individual feature or bug fix |

⚠️ Direct commits to `main` are not allowed.

---

## Development Flow

1. Work is done in **DEV sandbox**
2. Metadata is retrieved using `package.xml`
3. Changes are committed to a `feature/*` branch
4. Feature branch is merged into `sandbox`
5. CI validation runs automatically against **QA org**
6. After successful validation, code is promoted to `main`

---

## CI (Continuous Integration)

This project uses **GitHub Actions** to validate Salesforce deployments.

### What CI Does
- Authenticates to QA org
- Runs **check-only deployment**
- Executes `RunLocalTests`
- Blocks deployment if validation fails

CI configuration file:
