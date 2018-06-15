class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def create
    @game = Game.new(game_uuid: SecureRandom.uuid)
    
    if @game.save
      redirect_to game_path(id: @game.game_uuid)
    else
      render 'index'
    end
  end

  def show
    @game = Game.find_by(game_uuid: params[:id])
    @game_uuid = @game.game_uuid
  end
end
