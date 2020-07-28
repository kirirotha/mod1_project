class CreateGames < ActiveRecord::Migration[5.2]
    def change
        create_table :games do |t|
            t.string :name
            t.string :platform
            t.string :genre
            t.string :rating
            t.string :description
            t.integer :stock
        end
    end
end