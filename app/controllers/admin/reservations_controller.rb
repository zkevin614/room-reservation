module Admin
  class ReservationsController < BaseController
    before_action :set_reservation, only: %i[approve deny]

    def index
      @reservations = Reservation.pending.includes(:user, room: :site).order(:created_at, :starts_at)
    end

    def approve
      if @reservation.approve!(by: Current.user)
        redirect_back fallback_location: admin_reservations_path, notice: "Reservation approved."
      else
        redirect_back fallback_location: admin_reservations_path, alert: @reservation.errors.full_messages.to_sentence.presence || "Could not approve reservation."
      end
    end

    def deny
      if @reservation.deny!(by: Current.user)
        redirect_back fallback_location: admin_reservations_path, notice: "Reservation denied."
      else
        redirect_back fallback_location: admin_reservations_path, alert: @reservation.errors.full_messages.to_sentence.presence || "Could not deny reservation."
      end
    end

    private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
  end
end
