module Admin
  class RoomsController < BaseController
    before_action :set_room, only: %i[edit update destroy]

    def index
      @rooms = Room.includes(:site).joins(:site).order("sites.name", "rooms.name")
    end

    def new
      @room = Room.new(active: true, site_id: params[:site_id])
      @sites = Site.order(:name)
    end

    def create
      @room = Room.new(room_params)

      if @room.save
        redirect_to admin_rooms_path, notice: "Room created."
      else
        @sites = Site.order(:name)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @sites = Site.order(:name)
    end

    def update
      if @room.update(room_params)
        redirect_to admin_rooms_path, notice: "Room updated."
      else
        @sites = Site.order(:name)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @room.reservations.exists?
        redirect_to admin_rooms_path, alert: "Cannot delete a room that has reservations."
      elsif @room.destroy
        redirect_to admin_rooms_path, notice: "Room deleted."
      else
        redirect_to admin_rooms_path, alert: @room.errors.full_messages.to_sentence.presence || "Could not delete room."
      end
    end

    private

    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:name, :active, :site_id)
    end
  end
end
