class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :decided_by, class_name: "User", optional: true

  enum :status, { pending: "pending", approved: "approved", denied: "denied" }, validate: true
end
