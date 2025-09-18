class CreateTweets < ActiveRecord::Migration[7.2]
  def change
    create_table :tweets do |t|
      t.string :name
      t.string :event
      t.string :genre
      t.datetime :datefrom
      t.datetime :dateto
      t.string :area
      t.string :address
      t.text :about
      t.text :eventurl
      t.integer :user_id
      t.timestamps
    end
  end
end
