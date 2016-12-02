class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :picture
      t.string :title
      t.string :description
      t.integer :viewNum
      t.string :price
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
