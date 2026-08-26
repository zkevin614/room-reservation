class Room < ApplicationRecord
  belongs_to :site
  has_many :reservations, dependent: :restrict_with_exception
end
