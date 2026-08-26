class ReservationsController < ApplicationController
  before_action :set_room, only: %i[new create]

  def index
    @reservations = Current.user.reservations.upcoming.includes(room: :site)
  end

  def new
    @reservation = Current.user.reservations.new(room: @room, status: :pending)
  end

  def create
    @reservation = Current.user.reservations.new(reservation_params)
    @reservation.room = @room
    @reservation.status = :pending

    if @reservation.save
      redirect_to reservations_path, notice: "Reservation requested."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.active.find_by(id: params[:room_id] || params.dig(:reservation, :room_id))
    return if @room

    redirect_to root_path, alert: "Room not found or inactive."
  end

  def reservation_params
    params.require(:reservation).permit(:purpose, :starts_at, :ends_at)
  end
end
