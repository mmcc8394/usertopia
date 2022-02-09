class SaveMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :name, null: false
      t.text :phone, null: false
      t.text :email, null: false

      t.timestamps
    end
  end
end
