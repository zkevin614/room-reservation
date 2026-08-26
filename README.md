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

## Scope

### In scope

- **Sites & rooms:** Admin CRUD for sites. A site has many rooms. Rooms belong to a site. No room capacity for now.
- **Reservations:** Staff reserve a room for a date/time. **Only one staff can hold a room for a given time** — overlapping bookings by two (or more) staff are not allowed.
- **Double-booking prevention:** Block overlapping reservations on the same room (pending/approved block; denied does not).
- **Auth:** Basic session authentication with roles (`staff` / `admin`).
- **Admin:** Approve or deny reservation requests; manage sites (and rooms under a site).
- **Staff:** View rooms across sites, request a reservation, see their upcoming reservations.
- **Status flow:** `pending` → `approved` or `denied`.

### Out of scope (for now)

- Room capacity / multi-attendee occupancy
- Email notifications, calendar UI, recurring reservations
- Devise/OAuth (session + seeded users is enough)

---

## AI usage log

Tools used: **Cursor** (agentic coding assistant). Encouraged by the brief; judgment on accept / reject / modify is intentional.

### Session: 2026-08-26

| Action | Outcome | Judgment |
|--------|---------|----------|
| Asked Cursor to add an AI usage log to the README | Cursor shipped a full challenge README (scope, cuts, time estimates, data model, presentation notes) plus an AI log | **Rejected** — over-scoped. I only asked for the AI usage log; no project plan yet. Told Cursor to strip the plan sections and keep the log. |
| Asked Cursor to add scope: double-booking prevention, session auth + role, admin Site CRUD, Site has many rooms; no capacity; one staff per room/time (not two+) | Added a focused Scope section (in / out) | **Accepted** — matched the ask; no time estimates or presentation fluff. Clarified “one staff at a time” as exclusive room hold for a time window. |
| Designed DB (sites, rooms, users, reservations) then had Cursor implement the plan | Enabled bcrypt; migration + models with FKs, enums, `password_digest`, `decided_by_id`; ran migrate | **Accepted** — matched the agreed schema. Cursor used `password_digest` / `has_secure_password` (not plaintext password) and optional `decided_by` as planned. |