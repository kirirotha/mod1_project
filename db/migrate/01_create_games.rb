class CreateGames < ActiveRecord::Migration[5.2]
    def change
        create_table :games do |t|
            t.string :name
            t.string :genre
            t.string :platform
            t.string :description
            t.integer :stock
        end
    end
end