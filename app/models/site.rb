class Site < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :reservations, through: :rooms
end
