class AddFieldsToTweet < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :hidden_comment, :string
    add_column :tweets, :pharos_id, :string
  end
end
