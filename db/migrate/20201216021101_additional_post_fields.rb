class AdditionalPostFields < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :text
    add_column :users, :last_name, :text
    change_column_null :users, :first_name, false, 'Jane'
    change_column_null :users, :last_name, false, 'Doe'

    add_column :posts, :meta_description, :text
    change_column_null :posts, :meta_description, false, 'lorem ipsum'
    add_column :posts, :published_on, :datetime
    add_column :posts, :published_by, :integer
    Post.reset_column_information
  end
end
