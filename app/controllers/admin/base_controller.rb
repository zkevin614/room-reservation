module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    private

    def require_admin
      return if Current.user&.admin?

      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
