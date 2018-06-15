class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :game_uuid
      t.string :host_uuid
      t.string :opponent_uuid
      t.string :host_piece

      t.timestamps
    end
  end
end
