require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @room = rooms(:conference)
    @user = users(:one)
    @other_user = users(:two)
    @day = Time.zone.parse("2026-09-01 00:00:00")
  end

  test "overlapping pending reservation is invalid" do
    create_reservation!(starts_at: @day + 9.hours, ends_at: @day + 10.hours, status: :pending)

    conflict = build_reservation(starts_at: @day + 9.hours + 30.minutes, ends_at: @day + 10.hours + 30.minutes)

    assert_not conflict.valid?
    assert_includes conflict.errors[:base], "Room is already reserved for this time"
  end

  test "overlapping approved reservation is invalid" do
    create_reservation!(starts_at: @day + 9.hours, ends_at: @day + 10.hours, status: :approved)

    conflict = build_reservation(starts_at: @day + 9.hours, ends_at: @day + 10.hours, user: @other_user)

    assert_not conflict.valid?
  end

  test "denied reservation does not block the slot" do
    create_reservation!(starts_at: @day + 9.hours, ends_at: @day + 10.hours, status: :denied)

    replacement = build_reservation(starts_at: @day + 9.hours, ends_at: @day + 10.hours, user: @other_user)

    assert replacement.valid?
  end

  test "cancelled reservation does not block the slot" do
    create_reservation!(starts_at: @day + 9.hours, ends_at: @day + 10.hours, status: :cancelled)

    replacement = build_reservation(starts_at: @day + 9.hours, ends_at: @day + 10.hours, user: @other_user)

    assert replacement.valid?
  end

  test "denied status skips overlap validation so admin can deny" do
    create_reservation!(starts_at: @day + 9.hours, ends_at: @day + 10.hours, status: :pending)

    denied = build_reservation(
      starts_at: @day + 9.hours,
      ends_at: @day + 10.hours,
      status: :denied,
      user: @other_user
    )

    assert denied.valid?
  end

  test "updating to denied skips overlap validation" do
    reservation = create_reservation!(starts_at: @day + 9.hours, ends_at: @day + 10.hours, status: :pending)
    create_reservation!(starts_at: @day + 11.hours, ends_at: @day + 12.hours, status: :pending, user: @other_user)

    reservation.assign_attributes(
      starts_at: @day + 11.hours,
      ends_at: @day + 12.hours,
      status: :denied
    )

    assert reservation.valid?
  end

  private

  def build_reservation(starts_at:, ends_at:, status: :pending, user: @user)
    Reservation.new(
      room: @room,
      user: user,
      purpose: "Meeting",
      starts_at: starts_at,
      ends_at: ends_at,
      status: status
    )
  end

  def create_reservation!(starts_at:, ends_at:, status: :pending, user: @user)
    build_reservation(starts_at: starts_at, ends_at: ends_at, status: status, user: user).tap(&:save!)
  end
end
