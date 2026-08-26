# Room Reservation System

Rails app for reserving rooms across multiple sites (Tuscarora IU 11 coding challenge).

**Stack:** Ruby on Rails 8.1 · PostgreSQL · Hotwire (Turbo/Stimulus)

## How to run

```bash
# Prerequisites: Ruby 3.3.6, PostgreSQL
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000).

---

## AI usage log

Tools used: **Cursor** (agentic coding assistant). Encouraged by the brief; judgment on accept / reject / modify is intentional.

### Session: 2026-08-26

| Action | Outcome | Judgment |
|--------|---------|----------|
| Asked Cursor to add an AI usage log to the README | Cursor shipped a full challenge README (scope, cuts, time estimates, data model, presentation notes) plus an AI log | **Rejected** — over-scoped. I only asked for the AI usage log; no project plan yet. Told Cursor to strip the plan sections and keep the log. |