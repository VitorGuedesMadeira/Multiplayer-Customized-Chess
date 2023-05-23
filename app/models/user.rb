class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :games, through: :matches
  has_many :matches

  validates :name, presence: true, uniqueness: true,
  length: { maximum: 30, too_long: '%<count>s characters is the maximum allowed' }
end
