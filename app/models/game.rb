class Game < ApplicationRecord
  def self.start_game(game_uuid, player_uuid)
    @game = Game.find_by(game_uuid: game_uuid)
    # Save host_uuid if not already saved
    if @game.host_uuid.nil?
      @game.update(host_uuid: player_uuid, host_piece: 'cross')
    else
      # Save opponent_uuid and begin game
      @game.update(opponent_uuid: player_uuid) unless @game.opponent_uuid.present?

      ActionCable.server.broadcast "game_#{game_uuid}_player_#{@game.host_uuid}", { action: 'game_start', msg: 'cross' }
      ActionCable.server.broadcast "game_#{game_uuid}_player_#{@game.opponent_uuid}", { action: 'game_start', msg: 'nought' }
    end
  end

  def self.select_square(game_uuid, player_uuid, data)
    puts "--- Game model self.select_square game_uuid = #{game_uuid}"
    puts "--- Game model self.select_square player_uuid = #{player_uuid}"
    @game = Game.find_by(game_uuid: game_uuid)

    if @game.host_uuid == player_uuid
      other_player_uuid = @game.opponent_uuid
      piece = 'X'
    else
      other_player_uuid = @game.host_uuid
      piece = 'O'
    end
    
    puts "--- Game model self.select_square other_player_uuid = #{other_player_uuid}"

    ActionCable.server.broadcast "game_#{game_uuid}_player_#{player_uuid}", { action: 'select_square', selection: data['data'], piece: piece }
    ActionCable.server.broadcast "game_#{game_uuid}_player_#{other_player_uuid}", { action: 'select_square', selection: data['data'], piece: piece }
  end
end
