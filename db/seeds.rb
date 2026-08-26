# Demo users for local sign-in (password for all: password)
[
  { name: "Admin User", email: "admin@example.com", role: :admin },
  { name: "Staff User 1", email: "staff1@example.com", role: :staff },
  { name: "Staff User 2", email: "staff2@example.com", role: :staff },
  { name: "Staff User 3", email: "staff3@example.com", role: :staff },
].each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.name = attrs[:name]
  user.role = attrs[:role]
  user.password = "password"
  user.save!
end
