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

  def check_available_positions(piece, startx, starty)
    valid_positions = []
    state.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        next unless valid_target?(startx, starty, row_index, col_index)

        case piece
        when 'pawn_1'
          valid_positions << [row_index, col_index] if pawn_one(startx, starty, row_index, col_index)
        when 'pawn_2'
          valid_positions << [row_index, col_index] if pawn_two(startx, starty, row_index, col_index)
        when 'knight_1', 'knight_2'
          valid_positions << [row_index, col_index] if knight(startx, starty, row_index, col_index)
        when 'bishop_1', 'bishop_2'
          valid_positions << [row_index, col_index] if valid_diagonal_move?(startx, starty, row_index, col_index) && !obstacles_on_path?(startx, starty, row_index, col_index)
        when 'rock_1', 'rock_2'
          valid_positions << [row_index, col_index] if valid_straight_move?(startx, starty, row_index, col_index) && !obstacles_on_path?(startx, starty, row_index, col_index)
        when 'queen_1', 'queen_2'
          valid_positions << [row_index, col_index] if (valid_straight_move?(startx, starty, row_index,
                                                                             col_index) || valid_diagonal_move?(startx, starty, row_index,
                                                                                                                col_index)) && !obstacles_on_path?(startx, starty, row_index, col_index)
        when 'king_1', 'king_2'

          valid_positions << [row_index, col_index] if (starty - col_index).abs <= 1 && (startx - row_index).abs <= 1 && !obstacles_on_path?(startx, starty, row_index, col_index)
        end
      end
    end
    valid_positions
  end

  def check_check
    # Check the enemies possible positions
    # if state[row_index][col_index] == 'king_1'
    #   white_king = [row_index, col_index]
    # end
    # if state[row_index][col_index] == 'king_2'
    #   black_king = [row_index, col_index]
    # end

    valid_positions = []
    state.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        next unless valid_target?(startx, starty, row_index, col_index)

        case state[row_index][col_index]
        when 'pawn_1'
          valid_positions << [row_index, col_index] if pawn_one(startx, starty, row_index, col_index)
        when 'pawn_2'
          valid_positions << [row_index, col_index] if pawn_two(startx, starty, row_index, col_index)
        when 'knight_1', 'knight_2'
          valid_positions << [row_index, col_index] if knight(startx, starty, row_index, col_index)
        when 'bishop_1', 'bishop_2'
          valid_positions << [row_index, col_index] if valid_diagonal_move?(startx, starty, row_index, col_index) && !obstacles_on_path?(startx, starty, row_index, col_index)
        when 'rock_1', 'rock_2'
          valid_positions << [row_index, col_index] if valid_straight_move?(startx, starty, row_index, col_index) && !obstacles_on_path?(startx, starty, row_index, col_index)
        when 'queen_1', 'queen_2'
          valid_positions << [row_index, col_index] if (valid_straight_move?(startx, starty, row_index,
                                                                             col_index) || valid_diagonal_move?(startx, starty, row_index,
                                                                                                                col_index)) && !obstacles_on_path?(startx, starty, row_index, col_index)
        when 'king_1', 'king_2'

          valid_positions << [row_index, col_index] if (starty - col_index).abs <= 1 && (startx - row_index).abs <= 1 && !obstacles_on_path?(startx, starty, row_index, col_index)
        end
      end
    end
    valid_positions
    # Check my king position
  end

  def valid_target?(startx, starty, finishx, finishy)
    # Checks if it is empty or if it is same team piece
    (state[finishy][finishx].blank? || state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1]) && state[starty][startx] != '' && state[finishx][finishy] != 'x'
  end

  def case_move(piece, startx, starty, finishx, finishy)
    return unless valid_target?(startx, starty, finishx, finishy)

    case piece
    when 'pawn_1'
      move_piece(startx, starty, finishx, finishy) if pawn_one(startx, starty, finishx, finishy)
    when 'pawn_2'
      move_piece(startx, starty, finishx, finishy) if pawn_two(startx, starty, finishx, finishy)
    when 'knight_1', 'knight_2'
      move_piece(startx, starty, finishx, finishy) if knight(startx, starty, finishx, finishy)
    when 'bishop_1', 'bishop_2'
      move_piece(startx, starty, finishx, finishy) if valid_diagonal_move?(startx, starty, finishx, finishy) && !obstacles_on_path?(startx, starty, finishx, finishy)
    when 'rock_1', 'rock_2'
      move_piece(startx, starty, finishx, finishy) if valid_straight_move?(startx, starty, finishx, finishy) && !obstacles_on_path?(startx, starty, finishx, finishy)
    when 'queen_1', 'queen_2'
      move_piece(startx, starty, finishx, finishy) if (valid_straight_move?(startx, starty, finishx,
                                                                            finishy) || valid_diagonal_move?(startx, starty, finishx,
                                                                                                             finishy)) && !obstacles_on_path?(startx, starty, finishx, finishy)
    when 'king_1', 'king_2'
      move_piece(startx, starty, finishx, finishy) if (starty - finishy).abs <= 1 && (startx - finishx).abs <= 1 && !obstacles_on_path?(startx, starty, finishx, finishy)

    end
  end

  def move(piece, startx, starty, finishx, finishy)
    if turn.even?
      return if piece.split('_')[1] == '2'
    elsif piece.split('_')[1] == '1'
      return
    end
    case_move(piece, startx, starty, finishx, finishy)
    save
  end

  def move_piece(startx, starty, finishx, finishy)
    self.turn += 1
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

  def obstacles_on_path?(startx, starty, finishx, finishy)
    row_diff = (finishx - startx).abs
    col_diff = (finishy - starty).abs

    if row_diff.zero? && col_diff.zero?
      return false # starting and ending positions are the same
    end

    # determine the direction of movement
    x_increment = startx < finishx ? 1 : -1 # positive = right / negative = left
    y_increment = starty < finishy ? 1 : -1 # positive = down  / negative = top

    # check for obstacles along the path
    if row_diff.zero? # vertical movement
      (starty + y_increment).step(finishy - y_increment, y_increment).each do |y|
        return true if state[y][startx].present?
      end
    elsif col_diff.zero? # horizontal movement
      (startx + x_increment).step(finishx - x_increment, x_increment).each do |x|
        return true if state[starty][x].present?
      end
    elsif row_diff == col_diff # diagonal movement
      (startx + x_increment).step(finishx - x_increment, x_increment).each_with_index do |x, i|
        y = starty + (y_increment * (i + 1))
        return true if state[y][x].present?
      end
    else
      return true # invalid movement
    end

    false # no obstacles on the path
  end

  def pawn_one(startx, starty, finishx, finishy)
    (starty - finishy == 1 && startx == finishx && state[finishy][finishx] == '') ||
      (starty - finishy == 1 && state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1] && (startx - finishx).abs == 1 && state[finishy][finishx] != '') ||
      (starty - finishy == 2 && startx == finishx && starty == 6)
  end

  def pawn_two(startx, starty, finishx, finishy)
    (finishy - starty == 1 && startx == finishx && state[finishy][finishx] == '') ||
      (finishy - starty == 1 && state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1] && (startx - finishx).abs == 1 && state[finishy][finishx] != '') ||
      (finishy - starty == 2 && startx == finishx && starty == 1)
  end

  def knight(startx, starty, finishx, finishy)
    ((starty - finishy).abs == 2 && (startx - finishx).abs == 1) ||
      ((starty - finishy).abs == 1 && (startx - finishx).abs == 2)
  end
end
