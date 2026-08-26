# Wipe all app data so seeds are deterministic.
Reservation.delete_all
Session.delete_all
Room.delete_all
Site.delete_all
User.delete_all

# Demo users for local sign-in (password for all: password)
[
  { name: "Admin User", email: "admin@example.com", role: :admin },
  { name: "Staff User 1", email: "staff1@example.com", role: :staff },
  { name: "Staff User 2", email: "staff2@example.com", role: :staff },
  { name: "Staff User 3", email: "staff3@example.com", role: :staff }
].each do |attrs|
  User.create!(
    name: attrs[:name],
    email: attrs[:email],
    role: attrs[:role],
    password: "password"
  )
end

# Sites and rooms across multiple campuses
[
  {
    name: "Main Campus",
    address: "100 School Road, McVeytown, PA",
    rooms: [ "Conference Room A", "Conference Room B", "Library Lab" ]
  },
  {
    name: "North Center",
    address: "250 Maple Avenue, Lewistown, PA",
    rooms: [ "Training Room", "Meeting Room 1" ]
  },
  {
    name: "South Annex",
    address: "40 River Street, Huntingdon, PA",
    rooms: [ "Board Room", "Computer Lab" ]
  }
].each do |site_attrs|
  site = Site.create!(
    name: site_attrs[:name],
    address: site_attrs[:address],
    active: true
  )

  site_attrs[:rooms].each do |room_name|
    site.rooms.create!(name: room_name, active: true)
  end
end
