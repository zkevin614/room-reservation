class Reservation < ApplicationRecord
  BLOCKING_STATUSES = %w[pending approved].freeze

  belongs_to :room
  belongs_to :user
  belongs_to :decided_by, class_name: "User", optional: true

  enum :status, {
    pending: "pending",
    approved: "approved",
    denied: "denied",
    cancelled: "cancelled"
  }, validate: true

  validates :starts_at, :ends_at, presence: true
  validate :ends_at_after_starts_at
  validate :no_overlapping_reservation

  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }

  def approve!(by:)
    unless pending?
      errors.add(:base, "Only pending reservations can be approved")
      return false
    end

    assign_attributes(status: :approved, decided_by: by, decided_at: Time.current)
    save
  end

  def deny!(by:)
    unless pending?
      errors.add(:base, "Only pending reservations can be denied")
      return false
    end

    assign_attributes(status: :denied, decided_by: by, decided_at: Time.current)
    save
  end

  private

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?
    return if ends_at > starts_at

    errors.add(:ends_at, "must be after start time")
  end

  def no_overlapping_reservation
    return if denied? || cancelled?
    return if room_id.blank? || starts_at.blank? || ends_at.blank?

    overlapping = Reservation
      .where(room_id: room_id, status: BLOCKING_STATUSES)
      .where("starts_at < ? AND ends_at > ?", ends_at, starts_at)
    overlapping = overlapping.where.not(id: id) if persisted?

    errors.add(:base, "Room is already reserved for this time") if overlapping.exists?
  end
end
