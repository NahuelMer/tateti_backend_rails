class CreatePlayers < ActiveRecord::Migration[7.0]
  # levanto un tablero unico en el back y controlo quien esta haciendo el put quiza mediante token
  # lograr que se pueda jugar completamente en el back
  # necesito solo 2 players que se creen por default
  def change
    create_table :players do |t|
      t.string :player_name
      t.string :token

      t.timestamps
    end
  end
end
