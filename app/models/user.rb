class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Rails authentication generator uses email_address; our column is email.
  alias_attribute :email_address, :email

  has_many :reservations, dependent: :restrict_with_exception
  has_many :decided_reservations, class_name: "Reservation", foreign_key: :decided_by_id, inverse_of: :decided_by, dependent: :nullify

  enum :role, { staff: "staff", admin: "admin" }, validate: true

  normalizes :email, with: ->(e) { e.strip.downcase }
end
