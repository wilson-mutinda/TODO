class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.text :task
      t.string :status

      t.timestamps
    end
  end
end
