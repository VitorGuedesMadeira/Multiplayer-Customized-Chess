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

  def move(piece, startx, starty, finishx, finishy)
    type = piece.split('_')[0]
    color = piece.split('_')[1]
    # Checks if it is empty or if it is same team piece
    if (state[finishy][finishx].blank? || state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1]) && state[starty][startx] != ''
      case piece
      when 'pawn_1'
        if starty - finishy == 1 && startx == finishx && state[finishy][finishx] == ''
          state[finishy][finishx] = state[starty][startx]
          state[starty][startx] = ''
          # Adds move to moves
          moves << [startx, starty, finishx, finishy]
        elsif starty - finishy == 1 && state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1] && (startx - finishx).abs == 1 && state[finishy][finishx] != ''
          state[finishy][finishx] = state[starty][startx]
          state[starty][startx] = ''
          # Adds move to moves
          moves << [startx, starty, finishx, finishy]
        elsif starty - finishy == 2 && startx == finishx && starty == 6
          state[finishy][finishx] = state[starty][startx]
          state[starty][startx] = ''
          # Adds move to moves
          moves << [startx, starty, finishx, finishy]
        end
      when 'pawn_2'
        if finishy - starty == 1 && startx == finishx && state[finishy][finishx] == ''
          state[finishy][finishx] = state[starty][startx]
          state[starty][startx] = ''
          # Adds move to moves
          moves << [startx, starty, finishx, finishy]
        elsif finishy - starty == 1 && state[finishy][finishx].split('_')[1] != state[starty][startx].split('_')[1] && (startx - finishx).abs == 1 && state[finishy][finishx] != ''
          state[finishy][finishx] = state[starty][startx]
          state[starty][startx] = ''
          # Adds move to moves
          moves << [startx, starty, finishx, finishy]
        elsif finishy - starty == 2 && startx == finishx && starty == 1
          state[finishy][finishx] = state[starty][startx]
          state[starty][startx] = ''
          # Adds move to moves
          moves << [startx, starty, finishx, finishy]
        end
      end
    end

    # if finishy - starty == 1
    #   state[finishy][finishx] = state[starty][startx]
    #   state[starty][startx] = ''
    # end
    # p "##################"
    # p piece
    save
  end
end
