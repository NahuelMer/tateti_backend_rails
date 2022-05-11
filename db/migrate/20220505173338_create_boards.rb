class CreateBoards < ActiveRecord::Migration[7.0]
  # no se si se puede hacer esto
  def change
    create_table :boards do |t|
      # t.string :cells, array: true, default: [
      #   ["", "", ""],
      #   ["", "", ""],
      #   ["", "", ""],
      #   ]

      t.json :cells, default: {
        0 => { 0 => nil, 1 => nil, 2 => nil},
        1 => { 0 => nil, 1 => nil, 2 => nil},
        2 => { 0 => nil, 1 => nil, 2 => nil},
      }

      t.boolean :game_ended, default: false
      t.string :turn_name, default: "X"
      t.integer :turn_counter, default: 0
      t.string :token

      t.timestamps
    end
  end
end
