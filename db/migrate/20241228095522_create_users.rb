class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :clerk_id, null: false
      t.string :image_url
      t.timestamps
    end
  end
end
