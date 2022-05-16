class CreateBoardPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :board_players, id: false do |t|
      t.string :chip
      t.belongs_to :board
      t.belongs_to :player

      t.timestamps
    end
  end
end
