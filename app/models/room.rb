class Room < ApplicationRecord
  belongs_to :site
  has_many :reservations, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }

  scope :active, -> { where(active: true) }
end
