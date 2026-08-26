# Notes

## AI usage log

Tools used: **Cursor** (agentic coding assistant). Encouraged by the brief; judgment on accept / reject / modify is intentional.

### Session: 2026-08-26

| Action | Outcome | Judgment |
|--------|---------|----------|
| Asked Cursor to add an AI usage log to the README | Cursor shipped a full challenge README (scope, cuts, time estimates, data model, presentation notes) plus an AI log | **Rejected** — over-scoped. I only asked for the AI usage log; no project plan yet. Told Cursor to strip the plan sections and keep the log. |
| Asked Cursor to add scope: double-booking prevention, session auth + role, admin Site CRUD, Site has many rooms; no capacity; one staff per room/time (not two+) | Added a focused Scope section (in / out) | **Accepted** — matched the ask; no time estimates or presentation fluff. Clarified “one staff at a time” as exclusive room hold for a time window. |
| Designed DB (sites, rooms, users, reservations) then had Cursor implement the plan | Enabled bcrypt; migration + models with FKs, enums, `password_digest`, `decided_by_id`; ran migrate | **Accepted** — matched the agreed schema. Cursor used `password_digest` / `has_secure_password` (not plaintext password) and optional `decided_by` as planned. |
| Asked Cursor to move the AI usage log out of README into NOTES.md | Moved log to [NOTES.md](NOTES.md); README keeps setup + scope | **Accepted** — keeps the challenge log separate from the runbook. |
| Ran `rails generate authentication`; asked Cursor for user seeds | Seeded admin + staff (`password`); added `has_many :sessions` and `email`↔`email_address` alias so generator login works with our schema | **Accepted with small intervene** — kept our `email` column; aliased instead of renaming to match generator. |
| Login blew up on `root_url` after session create; asked to fix post-auth redirect | Added `HomeController#index` and `root "home#index"` so `after_authentication_url` resolves | **Accepted** — method already existed; missing root route was the real bug. |
| Double-booking rules: pending/approved block; denied/cancelled release; model validation; skip overlap check when denying/cancelling | Added `cancelled` status, overlap validation, model tests; updated README | **Accepted** — matched settled rules (validation + skip on deny/cancel). |
| Asked Cursor to complete Site and Room models to match Postgres tables | Validations for `name` / `active`; `active` scopes; kept associations | **Accepted** — mirrors columns (`name`, `address`, `active` / `site`, `name`, `active`). |
| Asked Cursor to seed sites/rooms and wipe all tables first | `delete_all` in FK order, then recreate users, 3 sites, 7 rooms | **Accepted**. |