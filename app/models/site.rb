class Site < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :reservations, through: :rooms

  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }

  scope :active, -> { where(active: true) }
end
