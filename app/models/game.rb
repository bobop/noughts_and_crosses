class Game < ApplicationRecord
  has_many :game_turns

  def self.start_game(game_uuid, player_uuid)
    @game = Game.find_by(game_uuid: game_uuid)
    # Save host_uuid if not already saved
    if @game.host_uuid.nil?
      @game.update(host_uuid: player_uuid, host_piece: 'cross')
    else
      # Save opponent_uuid and begin game
      @game.update(opponent_uuid: player_uuid) unless @game.opponent_uuid.present?

      ActionCable.server.broadcast "game_#{game_uuid}_player_#{@game.host_uuid}", {
        action: 'game_start',
        msg: 'You are X',
        turn: 'Your turn'
      }
      ActionCable.server.broadcast "game_#{game_uuid}_player_#{@game.opponent_uuid}", {
        action: 'game_start',
        msg: 'You are O',
        turn: 'Other player\'s turn'
      }
    end
  end

  def self.select_square(game_uuid, player_uuid, data)
    # puts "--- Game model self.select_square game_uuid = #{game_uuid}"
    # puts "--- Game model self.select_square player_uuid = #{player_uuid}"
    @game = Game.find_by(game_uuid: game_uuid)

    # Determine the last player who made a move
    # last_player = @game.game_turns.empty? ? nil : @game.game_turns.last.player

    if @game.host_uuid == player_uuid
      player = 'host'
      other_player_uuid = @game.opponent_uuid
      piece = 'X'
    else
      player = 'opponent'
      other_player_uuid = @game.host_uuid
      piece = 'O'
    end
    # puts "--- Game model self.select_square other_player_uuid = #{other_player_uuid}"

    # Do not continue if current player was also the last player
    # return if last_player == player

    @game.game_turns.create(square_number: data['data'].to_i, player: player)

    # Check to see if Game has been won by current player_uuid
    winning_squares = [
      [1,2,3],
      [4,5,6],
      [7,8,9],
      [1,4,7],
      [2,5,8],
      [3,6,9],
      [1,5,9],
      [3,5,7]
    ]
    player_squares = @game.game_turns.where(player: player).collect(&:square_number).sort
    # puts "--- Game select_square player_squares = #{player_squares.inspect}"

    game_won = false
    winning_squares.each do |winning_array|
      # puts "--- Game select_square winning_array = #{winning_array.inspect}"
      square_array = (winning_array - player_squares)
      # puts "--- Game select_square square_array = #{square_array.inspect}"
      if square_array.empty?
        game_won = true
        break
      end
    end
      
    ActionCable.server.broadcast "game_#{game_uuid}_player_#{player_uuid}", { 
      action: 'select_square',
      selection: data['data'],
      piece: piece,
      turn: 'Other player\'s turn',
      game_won: game_won ? 'Congratulations, you won :)' : ''
    }
    ActionCable.server.broadcast "game_#{game_uuid}_player_#{other_player_uuid}", {
      action: 'select_square',
      selection: data['data'],
      piece: piece,
      turn: 'Your turn',
      game_won: game_won ? 'Sorry, you lost :(' : ''
     }
  end
end
