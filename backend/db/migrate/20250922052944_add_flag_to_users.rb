class AddFlagToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :flag, :string
  end
end
