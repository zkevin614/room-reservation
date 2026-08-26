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

### Demo users (after `db:seed`)

| Role  | Email               | Password |
|-------|---------------------|----------|
| Admin | admin@example.com   | password |
| Staff | staff1@example.com   | password |
| Staff | staff2@example.com   | password |
| Staff | staff3@example.com   | password |
---

## Scope

### In scope

- **Sites & rooms:** A site has many rooms. Rooms belong to a site. No room capacity for now. Sites/rooms come from seeds (no admin CRUD).
- **Reservations:** Staff reserve a room for a date/time. **Only one staff can hold a room for a given time** — overlapping bookings by two (or more) staff are not allowed.
- **Double-booking prevention:** Block overlapping reservations on the same room (`pending`/`approved` hold the slot; `denied`/`cancelled` release it).
- **Auth:** Basic session authentication with roles (`staff` / `admin`).
- **Admin:** Approve or deny reservation requests.
- **Staff:** View rooms across sites, request a reservation, see their upcoming reservations, and cancel pending/approved ones.
- **Status flow:** `pending` → `approved`, `denied`, or `cancelled` (staff may cancel pending/approved).

### Out of scope (for now)

- Admin CRUD for sites and rooms
- Room capacity / multi-attendee occupancy
- Email notifications, calendar UI, recurring reservations
- Devise/OAuth (session + seeded users is enough)

AI usage log: see [NOTES.md](NOTES.md).
