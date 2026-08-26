# Room Reservation System

Coding challenge for **Tuscarora Intermediate Unit 11** — a Rails app for staff to reserve rooms across multiple sites, with admin approval and double-booking prevention.

**Stack:** Ruby on Rails 8.1 · PostgreSQL · Hotwire (Turbo/Stimulus) · Pico CSS

**Challenge budget:** 3 hours

## How to run

```bash
# Prerequisites: Ruby 3.3.6, PostgreSQL
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000).

### Demo users (after `db:seed`)

| Role  | Email                | Password |
|-------|----------------------|----------|
| Admin | admin@example.com    | password |
| Staff | staff1@example.com   | password |
| Staff | staff2@example.com   | password |
| Staff | staff3@example.com   | password |

Seeds also create three sites (Main Campus, North Center, South Annex) with seven rooms.

## Project plan

The brief asks for a working slice, not a finished product. I prioritized a **vertical path**: log in → see rooms by site → request a time → admin approves or denies → the room cannot be double-booked.

### Scope decisions

**In (core requirements)**

- **Staff:** View active rooms grouped by site, reserve a date/time, see upcoming approved reservations, see own request history, cancel pending/approved bookings that have not ended.
- **Admin:** Approve or deny pending requests (oldest created first). Manage sites and rooms (create, edit, activate/deactivate, delete when there are no reservations).
- **Shared Rooms page:** Per-room upcoming pending/approved schedule so everyone can see who holds which slot. Staff can cancel their own rows; admin can approve/deny pending rows there.
- **Double-booking:** Only an **approved** reservation holds the slot. Multiple **pending** requests may compete; admin chooses. Denied and cancelled do not block.
- **Auth:** Rails 8 session authentication with `staff` / `admin` roles. Seeded demo users — no Devise.
- **Status:** `pending` → `approved`, `denied`, or `cancelled`.

**Decisions that shaped the model**

- Four tables only: `sites`, `rooms`, `users`, `reservations`. A site has many rooms; a reservation belongs to a room and a user. Approve/deny records `decided_by` and `decided_at`.
- No room capacity. One approved booking owns a time window — not two staff in the same room at once.
- Overlap is enforced in the model (`starts_at < other.ends_at AND ends_at > other.starts_at`).
- Pending does **not** block other pending requests. First version treated pending as a hold (FCFS). That was wrong for this product: staff should be able to compete, and admin should pick. Corrected to **approved-only** blocking.

### What I cut and why

| Cut | Why |
|-----|-----|
| Room capacity / multi-attendee occupancy | Explicit early call. Exclusive hold is simpler and matches “one staff at a time.” |
| Calendar UI / recurring reservations | Tables + datetime fields are enough to prove booking and conflicts. A calendar is a product, not a slice. |
| Devise / OAuth | Rails authentication generator + seeds is enough to show roles. |
| Postgres exclusion constraint + half-open intervals | Over-modeled. A validation is visible on the form; constraint/interval semantics cost time and were reverted. |
| Individual show pages for sites/rooms | Lists + edit forms are enough to manage records. |
| Rich test coverage | Model tests cover overlap/approve/deny/cancel. Controller/system tests were skipped to keep building the slice. |

### Time estimates vs. actuals

Challenge clock is **3 hours**. But it took **4 hours** overall.

### What I would do next with more time

1. **System tests** for the happy paths: staff request → admin approve → second overlapping approve fails; staff cancel; inactive rooms hidden.
2. **Stronger conflict handling in the UI** — show competing pending requests on the same slot so admin can compare before approving.
3. **Audit trail on the reservation** — who cancelled, and a simple history, since deny/approve already record a decider.
4. **Email (or at least in-app flash that’s hard to miss)** when a request is approved or denied.
5. **Calendar or week grid** once the table schedule gets painful for busy sites.
6. **Postgres exclusion constraint** on approved ranges only, after the product rule is stable.

## What each role can do

### Staff

- **Rooms:** Browse active sites and rooms. See upcoming pending and approved bookings per room. Request a reservation. Cancel your own upcoming pending/approved bookings from the row.
- **Upcoming reservations:** Your **approved** bookings that have not ended yet.
- **My reservations:** All of **your** requests (pending, approved, denied, cancelled). Cancel pending/approved ones that have not ended.

### Admin

- **Rooms:** Same per-room schedule. No Reserve button. Approve or deny **pending** rows from the schedule.
- **Pending requests:** All pending reservations, oldest created first. Approve or deny.
- **Manage Sites / Manage Rooms:** Create, edit, activate/deactivate, delete (blocked if reservations exist). Inactive records are hidden from the staff Rooms page.

## Booking rules

- New requests start as **pending**.
- Multiple **pending** requests may overlap; only one **approved** booking may hold the slot.
- **Denied** and **cancelled** do not block.
- Staff may cancel their own pending or approved reservation while `ends_at` is still in the future.
- Status flow: `pending` → `approved`, `denied`, or `cancelled`.

AI usage log: see [NOTES.md](NOTES.md).
