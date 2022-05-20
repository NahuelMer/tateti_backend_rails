class CreatePlayers < ActiveRecord::Migration[7.0]

  def change
    create_table :players do |t|
      t.string :player_name
      t.string :password
      t.string :token

      t.timestamps
    end
  end
end
