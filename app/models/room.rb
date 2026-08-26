class Room < ApplicationRecord
  belongs_to :site
  has_many :reservations, dependent: :restrict_with_exception
  has_many :upcoming_bookings, -> {
    where(status: %w[pending approved])
      .where("starts_at >= ?", Time.current)
      .order(:starts_at)
  }, class_name: "Reservation"

  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }

  scope :active, -> { where(active: true) }
end
