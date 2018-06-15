class GameChannel < ApplicationCable::Channel
  def subscribed
    # puts "--- GameChannel uuid = #{uuid}"
    # puts "--- GameChannel game_uuid = #{params[:game_uuid]}"
    stream_from "game_#{params[:game_uuid]}_player_#{uuid}"

    # Run start_game to set up host or opponent
    Game.start_game(params[:game_uuid], uuid)
  end

  def select_square(data)
    # puts "--- GameChannel select_square data = #{data.inspect}"
    Game.select_square(params[:game_uuid], uuid, data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
