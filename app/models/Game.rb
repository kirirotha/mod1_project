
class Game < ActiveRecord::Base
    has_many :checkouts
    has_many :users, through: :checkouts
end