class Game < ApplicationRecord
  validates :time, presence: true
  validates :theme, presence: true
  validates :mode, presence: true
end
