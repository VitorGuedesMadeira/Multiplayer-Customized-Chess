class Game < ApplicationRecord
  validates :time, presence: true
  validates :theme, presence: true
  validates :mode, presence: true

  attribute :time, :integer, default: 0
  attribute :theme, :integer, default: 0
  attribute :mode, :integer, default: 0
  attribute :turn, :integer, default: 0
  attribute :status, :integer, default: 0
  attribute :moves, :json, default: []

  enum time: { ten_minutes: 0, five_minutes: 1, one_minute: 2 }
  enum theme: { default: 0, harry_potter: 1, lotr: 2 }
  enum mode: { one_vs_one: 0, two_vs_two: 1, free_for_all: 2 }

  before_create :set_board

  after_update_commit { broadcast_update }

  def set_board
    self.state = case mode
                 when 'one_vs_one'
                   [
                     ['rock_2', 'knight_2', 'bishop_2', 'queen_2', 'king_2', 'bishop_2', 'knight_2', 'rock_2'],
                     ['pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2'],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1'],
                     ['rock_1', 'knight_1', 'bishop_1', 'queen_1', 'king_1', 'bishop_1', 'knight_1', 'rock_1']
                   ]
                 when 'two_vs_two'
                   [
                     ['x', 'x', 'x', 'rock_2', 'knight_2', 'bishop_2', 'queen_2', 'king_2', 'bishop_2', 'knight_2', 'rock_2', 'x', 'x', 'x'],
                     ['x', 'x', 'x', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'x', 'x', 'x'],
                     ['x', 'x', 'x', '', '', '', '', '', '', '', '', 'x', 'x', 'x'],
                     ['rock_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'rock_4'],
                     ['knight_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'knight_4'],
                     ['bishop_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'bishop_4'],
                     ['king_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'queen_4'],
                     ['queen_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'king_4'],
                     ['bishop_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'bishop_4'],
                     ['knight_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'knight_4'],
                     ['rock_3', 'pawn_3', '', '', '', '', '', '', '', '', '', '', 'pawn_4', 'rock_4'],
                     ['x', 'x', 'x', '', '', '', '', '', '', '', '', 'x', 'x', 'x'],
                     ['x', 'x', 'x', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'x', 'x', 'x'],
                     ['x', 'x', 'x', 'rock_1', 'knight_1', 'bishop_1', 'queen_1', 'king_1', 'bishop_1', 'knight_1', 'rock_1', 'x', 'x', 'x']
                   ]
                 when 'free_for_all'
                   [
                     ['rock_2', 'knight_2', 'bishop_2', 'queen_2', 'king_2', 'bishop_2', 'knight_2', 'rock_2'],
                     ['pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2', 'pawn_2'],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['', '', '', '', '', '', '', ''],
                     ['pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1', 'pawn_1'],
                     ['rock_1', 'knight_1', 'bishop_1', 'queen_1', 'king_1', 'bishop_1', 'knight_1', 'rock_1']
                   ] end
  end

  def valid_target?(startx, starty, finishx, finishy)
    # Checks if it is empty or if it is same team piece
    (state[finishy][finishx].blank? || state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1]) && state[starty][startx] != ''
  end

  def move(piece, startx, starty, finishx, finishy)
    # Checks if it is empty or if it is same team piece
    if valid_target?(startx, starty, finishx, finishy)
      case piece
      when 'pawn_1'
        if starty - finishy == 1 && startx == finishx && state[finishy][finishx] == ''
          move_piece(startx, starty, finishx, finishy)
        elsif starty - finishy == 1 && state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1] && (startx - finishx).abs == 1 && state[finishy][finishx] != ''
          move_piece(startx, starty, finishx, finishy)
        elsif starty - finishy == 2 && startx == finishx && starty == 6
          move_piece(startx, starty, finishx, finishy)
        end

      when 'pawn_2'
        if finishy - starty == 1 && startx == finishx && state[finishy][finishx] == ''
          move_piece(startx, starty, finishx, finishy)
        elsif finishy - starty == 1 && state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1] && (startx - finishx).abs == 1 && state[finishy][finishx] != ''
          move_piece(startx, starty, finishx, finishy)
        elsif finishy - starty == 2 && startx == finishx && starty == 1
          move_piece(startx, starty, finishx, finishy)
        end

      when 'knight_1'
        if (starty - finishy == 2 || finishy - starty == 2) && (startx == finishx + 1 || startx == finishx - 1)
          move_piece(startx, starty, finishx, finishy)
        elsif (startx - finishx == 2 || finishx - startx == 2) && (starty == finishy + 1 || starty == finishy - 1)
          move_piece(startx, starty, finishx, finishy)
        end

      when 'knight_2'
        if (starty - finishy == 2 || finishy - starty == 2) && (startx == finishx + 1 || startx == finishx - 1)
          move_piece(startx, starty, finishx, finishy)
        elsif (startx - finishx == 2 || finishx - startx == 2) && (starty == finishy + 1 || starty == finishy - 1)
          move_piece(startx, starty, finishx, finishy)
        end

      when 'bishop_1'
        move_piece(startx, starty, finishx, finishy) if valid_diagonal_move?(startx, starty, finishx, finishy) && !obstacles_on_path?(startx, starty, finishx, finishy)

      when 'bishop_2'
        move_piece(startx, starty, finishx, finishy) if valid_diagonal_move?(startx, starty, finishx, finishy) && !obstacles_on_path?(startx, starty, finishx, finishy)

      when 'rock_1'
        move_piece(startx, starty, finishx, finishy) if valid_straight_move?(startx, starty, finishx, finishy) && !obstacles_on_path?(startx, starty, finishx, finishy)

      when 'rock_2'
        move_piece(startx, starty, finishx, finishy) if valid_straight_move?(startx, starty, finishx, finishy) && !obstacles_on_path?(startx, starty, finishx, finishy)

      when 'queen_1'
        if (valid_straight_move?(startx, starty, finishx, finishy) || valid_diagonal_move?(startx, starty, finishx, finishy)) && !obstacles_on_path?(startx, starty, finishx, finishy)
          move_piece(startx, starty, finishx, finishy)
        end

      when 'queen_2'
        if (valid_straight_move?(startx, starty, finishx, finishy) || valid_diagonal_move?(startx, starty, finishx, finishy)) && !obstacles_on_path?(startx, starty, finishx, finishy)
          move_piece(startx, starty, finishx, finishy)
        end

      when 'king_1'
        move_piece(startx, starty, finishx, finishy) if (starty - finishy).abs <= 1 && (startx - finishx).abs <= 1 && !obstacles_on_path?(startx, starty, finishx, finishy)

      when 'king_2'
        move_piece(startx, starty, finishx, finishy) if (starty - finishy).abs <= 1 && (startx - finishx).abs <= 1 && !obstacles_on_path?(startx, starty, finishx, finishy)
      end
    end
    save
  end

  def move_piece(startx, starty, finishx, finishy)
    state[finishy][finishx] = state[starty][startx]
    state[starty][startx] = ''
    # Adds move to moves
    moves << [startx, starty, finishx, finishy]
  end

  def valid_diagonal_move?(startx, starty, finishx, finishy)
    row_diff = (finishx - startx).abs
    col_diff = (finishy - starty).abs
    row_diff == col_diff
  end

  def valid_straight_move?(startx, starty, finishx, finishy)
    row_diff = (finishx - startx).abs
    col_diff = (finishy - starty).abs
    row_diff.zero? || col_diff.zero?
  end

  def obstacles_on_path?(start_x, start_y, end_x, end_y)
    dx = (end_x - start_x).abs
    dy = (end_y - start_y).abs

    if dx.zero? && dy.zero?
      return false # starting and ending positions are the same
    end

    # determine the direction of movement
    x_inc = start_x < end_x ? 1 : -1
    y_inc = start_y < end_y ? 1 : -1

    # check for obstacles along the path
    if dx.zero? # vertical movement
      (start_y + y_inc).step(end_y - y_inc, y_inc).each do |y|
        return true if state[y][start_x].present?
      end
    elsif dy.zero? # horizontal movement
      (start_x + x_inc).step(end_x - x_inc, x_inc).each do |x|
        return true if state[start_y][x].present?
      end
    elsif dx == dy # diagonal movement
      (start_x + x_inc).step(end_x - x_inc, x_inc).each_with_index do |x, i|
        y = start_y + (y_inc * (i + 1))
        return true if state[y][x].present?
      end
    else
      return true # invalid movement
    end

    false # no obstacles on the path
  end
end
