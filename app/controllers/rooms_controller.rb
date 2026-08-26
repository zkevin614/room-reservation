class RoomsController < ApplicationController
  def index
    @sites = Site.active.includes(:rooms).order(:name)
  end
end
