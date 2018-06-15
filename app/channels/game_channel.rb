class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "player_#{uuid}"
    puts "--- GameChannel uuid = #{uuid}"
    puts "--- GameChannel game_uuid = #{params[:game_uuid]}"
    stream_from "game_#{params[:game_uuid]}_player_#{uuid}"
    Game.find_by(game_uuid: params[:game_uuid]).update(host_uuid: uuid)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
