class GamesController < ApplicationController
  def show; end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params_required)

    if @game.save
      redirect_to game_path(@game), notice: 'Game was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

  private

  def params_required
    params.require(:game).permit(:state, :players, :turn, :moves, :time, :status, :theme, :mode)
  end
end
