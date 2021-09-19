class CreateBots < ActiveRecord::Migration[6.1]
  def change
    create_table :bots do |t|

      t.timestamps
    end
  end
end
