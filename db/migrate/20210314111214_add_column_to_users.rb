class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :condition_check_before_trip_is_ended, :boolean, default: false, null: false
    add_column :users, :physical_condition_poiint, :integer, default: 0, null: false
  end
end
