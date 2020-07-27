class CreateCheckouts < ActiveRecord::Migration[5.2]
    def change
        create_table :checkouts do |t|
            t.integer :user_id
            t.integer :game_id
            t.integer :rating
            t.string :comment
            t.datetime :checkout_date
            t.datetime :return_date
        end
    end
end