class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update move_piece join check_positions promotion]
  before_action :authenticate_user!

  def index
    @mini_games = Game.all.order(id: :asc)
  end

  def show; end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params_required)
    @match = Match.new(game: @game, user: current_user, color: ['white', 'black'].sample)
    if @game.save && @match.save
      @game.increment!(:players)
      redirect_to game_path(@game), notice: 'Game was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

  def move_piece
    color = current_user.matches.where(game: @game)[0].color
    if @game.status == "ongoing"
      if @game.turn.even? && color == 'white'
        @game.move(params[:piece], params[:currentx].to_i, params[:currenty].to_i, params[:targetx].to_i, params[:targety].to_i)
      end
      if @game.turn.odd? && color == 'black'
        @game.move(params[:piece], params[:currentx].to_i, params[:currenty].to_i, params[:targetx].to_i, params[:targety].to_i)
      end
      redirect_to game_path(@game)
    end
  end

  def check_positions
    available_positions = @game.check_available_positions(params[:piece], params[:currentx].to_i, params[:currenty].to_i)
    @game.check_check
    render json: available_positions
  end

  def promotion
    @game.set_promotion(params[:currenty], params[:currentx], params[:piece])
    redirect_to game_path(@game)
  end

  def join
    if !@game.matches.any? { |obj| obj.user_id == current_user.id }
      @game.increment!(:players)
      colors = @game.matches.map { |obj| obj.color }
      all_colors = Match.colors.keys
      available_colors = all_colors - colors
      Match.create!(game: @game, user: current_user, color: available_colors.sample)
      if @game.mode == "one_vs_one" && @game.players == 2
        @game.status = "ongoing"
        @game.save
      end
    end

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
