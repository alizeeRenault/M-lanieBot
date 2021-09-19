class CreateAlerts < ActiveRecord::Migration[6.1]
  def change
    create_table :alerts do |t|
      t.integer :tid
      t.string  :link
      t.string  :user_name
      t.string  :text
      t.string  :archive_link

      t.timestamps
    end
  end
end
