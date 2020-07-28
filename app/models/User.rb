class User < ActiveRecord::Base
    has_many :checkouts
    has_many :games, through: :checkouts

    def run
        puts "Welcome to the Compendium!"
    end



end