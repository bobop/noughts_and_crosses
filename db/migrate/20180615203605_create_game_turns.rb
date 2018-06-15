class CreateGameTurns < ActiveRecord::Migration[5.2]
  def change
    create_table :game_turns do |t|
      t.references :game, foreign_key: true
      t.integer :square_number
      t.string :player

      t.timestamps
    end
  end
end
