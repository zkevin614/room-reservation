class CreateSitesRoomsUsersReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :sites do |t|
      t.string :name, null: false
      t.string :address
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :rooms do |t|
      t.references :site, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: "staff"

      t.timestamps
    end
    add_index :users, :email, unique: true

    create_table :reservations do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :purpose
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :status, null: false, default: "pending"
      t.references :decided_by, foreign_key: { to_table: :users }
      t.datetime :decided_at

      t.timestamps
    end
    add_index :reservations, [ :room_id, :starts_at, :ends_at ]
    add_check_constraint :reservations, "ends_at > starts_at", name: "reservations_ends_at_after_starts_at"
  end
end
