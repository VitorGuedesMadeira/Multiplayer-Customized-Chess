class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update move_piece check_positions promotion]

  def index
    @mini_games = Game.all.order(id: :asc)
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

  def move_piece
    @game.move(params[:piece], params[:currentx].to_i, params[:currenty].to_i, params[:targetx].to_i, params[:targety].to_i)
    redirect_to game_path(@game)
  end

  def check_positions
    available_positions = @game.check_available_positions(params[:piece], params[:currentx].to_i, params[:currenty].to_i)
    @game.check_check
    render json: available_positions
  end

  def promotion
    @game.set_promotion(params[:currenty], params[:currentx], params[:piece])
    @game.check_mate
    redirect_to game_path(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def params_required
    params.require(:game).permit(:state, :players, :turn, :moves, :time, :status, :theme, :mode)
  end
end
