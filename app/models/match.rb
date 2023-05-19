class Match < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum color: { white: 1, black: 2 }
end
