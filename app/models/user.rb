class User < ApplicationRecord
  has_secure_password

  has_many :reservations, dependent: :restrict_with_exception
  has_many :decided_reservations, class_name: "Reservation", foreign_key: :decided_by_id, inverse_of: :decided_by, dependent: :nullify

  enum :role, { staff: "staff", admin: "admin" }, validate: true
end
