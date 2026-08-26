module ApplicationHelper
  def nav_item_active?(key)
    case key
    when :rooms
      controller_path == "rooms" || (controller_path == "reservations" && action_name.in?(%w[new create]))
    when :upcoming_reservations
      controller_path == "reservations" && action_name == "upcoming"
    when :my_reservations
      controller_path == "reservations" && action_name == "index"
    when :manage_sites
      controller_path == "admin/sites"
    when :manage_rooms
      controller_path == "admin/rooms"
    when :pending_requests
      controller_path == "admin/reservations"
    else
      false
    end
  end

  def nav_link_to(name, path, key:, **options)
    active = nav_item_active?(key)
    options[:class] = [options[:class], ("active" if active)].compact.join(" ")
    options[:aria] = (options[:aria] || {}).merge(current: (active ? "page" : nil)).compact

    link_to name, path, **options
  end
end
