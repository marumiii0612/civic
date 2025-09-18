class CreateGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :groups do |t|
      t.integer :number
      t.string :name
      t.string :catchphrase
      t.text :purpose
      t.text :about
      t.string :phone
      t.string :mail
      t.string :g_area
      t.string :g_address
      t.string :genre
      t.integer :establishment
      t.integer :member
      t.string :range
      t.integer :fee_year
      t.string :budget_2025
      t.string :url

      t.timestamps
    end
  end
end
