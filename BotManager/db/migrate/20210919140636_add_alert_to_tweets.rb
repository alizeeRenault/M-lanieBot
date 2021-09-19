class AddAlertToTweets < ActiveRecord::Migration[6.1]
  def change
    add_reference :tweets, :alert, null: false, foreign_key: true
  end
end
