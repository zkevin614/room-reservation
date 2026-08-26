class RoomsController < ApplicationController
  def index
    @sites = Site.active.includes(rooms: { upcoming_bookings: :user }).order(:name)
  end
end
