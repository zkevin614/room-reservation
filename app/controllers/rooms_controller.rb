class RoomsController < ApplicationController
  def index
    @sites = Site.active.includes(rooms: { approved_upcoming_reservations: :user }).order(:name)
  end
end
