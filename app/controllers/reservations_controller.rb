class ReservationsController < ApplicationController
  before_action :set_room, only: %i[new create]
  before_action :set_own_reservation, only: :cancel
  before_action :require_staff, only: :upcoming

  def index
    @reservations = Reservation
      .where(user_id: Current.user.id)
      .includes(room: :site)
      .order(starts_at: :desc)
  end

  def upcoming
    @reservations = Current.user.reservations.upcoming_approved.includes(room: :site)
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

  def cancel
    if @reservation.cancel!
      redirect_back fallback_location: root_path, notice: "Reservation cancelled."
    else
      redirect_back fallback_location: root_path, alert: @reservation.errors.full_messages.to_sentence.presence || "Could not cancel reservation."
    end
  end

  private

  def set_room
    @room = Room.active.find_by(id: params[:room_id] || params.dig(:reservation, :room_id))
    return if @room

    redirect_to root_path, alert: "Room not found or inactive."
  end

  def set_own_reservation
    @reservation = Current.user.reservations.find_by(id: params[:id])
    return if @reservation

    redirect_to reservations_path, alert: "Reservation not found."
  end

  def reservation_params
    params.require(:reservation).permit(:purpose, :starts_at, :ends_at)
  end

  def require_staff
    return unless Current.user&.admin?

    redirect_to root_path, alert: "Only staff can view upcoming reservations."
  end
end
