
## Publishing (verified 2026-09-18)

Two separate repos, two separate purposes:

| Repo | Contents |
|---|---|
| `opd116/opd1-tracker-standalone` | the application itself (backend/, frontend/, tests/) |
| `opd116/opd1-tracker-designs` | interface captures (`shots/`) and the three design explorations (`designs/`, `gallery/`) |

`opd116/opd1-tracker` is an **unrelated** project (Tauri 2 + React/TS + Flask) and must not be touched.

Token scopes differ, and the distinction has bitten this project twice:

- `GITHUB_TOKEN` (integration token) — **can push**, **cannot create repos** (403 `Resource not accessible by integration`).
- `GITHUB_PERSONAL_ACCESS_TOKEN` — can do both.

So to stand up a brand-new repo, create it with `GITHUB_PERSONAL_ACCESS_TOKEN`, then push with either.
Creating a repo via `GITHUB_TOKEN` will always fail; that is a scope limit, not a bug.

Verify a push against the API rather than trusting `git push` output — a repo whose
remote SHA does not match local looks identical to success from inside the sandbox.
