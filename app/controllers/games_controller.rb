class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update]

  def index
    @games = Game.all.order(id: :asc)
  end

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

  def set_game
    @game = Game.find(params[:id])
  end

  def params_required
    params.require(:game).permit(:state, :players, :turn, :moves, :time, :status, :theme, :mode)
  end
end
