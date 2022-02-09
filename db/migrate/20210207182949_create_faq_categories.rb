class CreateFaqCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :faq_categories do |t|
      t.text :title, null: false
      t.integer :list_order
      t.timestamps
    end
  end
end
