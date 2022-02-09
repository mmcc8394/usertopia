class CreateFaqs < ActiveRecord::Migration[6.0]
  def change
    create_table :faqs do |t|
      t.integer :faq_category_id, null: false
      t.text :question, null: false
      t.integer :list_order
      t.timestamps
    end
  end
end
