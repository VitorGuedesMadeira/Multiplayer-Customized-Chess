class Game < ApplicationRecord
  validates :state, presence: true
  validates :players, presence: true
  validates :turn, presence: true
  validates :moves, presence: true
  validates :time, presence: true
  validates :status, presence: true
  validates :theme, presence: true
  validates :mode, presence: true
end
