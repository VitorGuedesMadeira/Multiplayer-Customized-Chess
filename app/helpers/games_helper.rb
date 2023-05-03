module GamesHelper
  def get_moves(game)
    game.moves.map do |subarray|
      letters = ('a'..'h').to_a
      numbers = (1..8).to_a.reverse
      [letters[subarray[0]], numbers[subarray[1]], letters[subarray[2]], numbers[subarray[3]]].join
    end
  end
end
