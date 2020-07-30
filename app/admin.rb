def admin_menu
    prompt = TTY::Prompt.new

    puts `clear`
    compendium_image 
    puts "Welcome Administrator."

    admin_m = prompt.select("Please Select from the menu below:") do |menu|
        #menu.enum '.'
        menu.choice 'Games', 1
        menu.choice 'Users', 2
        menu.choice 'Checkouts', 3
        menu.choice 'Exit', 4
    end

    if admin_m == 1 
        admin_games_menu
    elsif admin_m == 2
        admin_users_menu
    elsif admin_m == 3
        admin_checkouts_menu
    elsif admin_m == 4 
        puts " "
        exit_menu= prompt.select("Are you sure you want to exit?") do |menu|
            #menu.enum '.'
            menu.choice 'Yes', 1
            menu.choice 'No', 2    
        end
        if exit_menu == 1
            exit
        elsif exit_menu == 2
            admin_menu
        end 
    end


end

def admin_games_menu
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image 


    admin_games_m = prompt.select("Please Select from the menu below:") do |menu|
        #menu.enum '.'
        menu.choice 'View All Games / Modify / Delete', 1
        menu.choice 'Add Game', 2
        
        menu.choice 'Go Back', 5
    end

    if admin_games_m == 1 
        admin_view_games
    elsif admin_games_m == 2 
        add_game
    elsif admin_games_m == 5 
        admin_menu
    end
end

def admin_view_games
    prompt = TTY::Prompt.new
    all_games = Game.all.map{|game| "#{game.name} - #{game.platform}"}.sort
    all_games_m  = prompt.select("Choose a game", all_games, filter: true)
    admin_game_info(all_games_m)
end

def admin_game_info(selected_game)
    prompt = TTY::Prompt.new
    puts `clear`
    data = selected_game.split(" - ")
    searched_game = Game.all.find{|game| game.name == data[0]}
    puts searched_game.name
    puts searched_game.platform
    puts searched_game.genre
    puts searched_game.rating
    puts searched_game.game_description
    puts "Stock: #{searched_game.stock}"
    puts " "
    browse_menu = prompt.select("Choose an option:") do |menu|
        #menu.enum '.'
        menu.choice 'Adjust Title', 1
        menu.choice 'Adjust Platform', 2
        menu.choice 'Adjust Genre', 3
        menu.choice 'Adjust Rating', 4
        menu.choice 'Adjust Description', 5
        menu.choice 'Adjust Stock', 6
        menu.choice 'Remove Game', 7
        menu.choice 'Go Back', 8
    end
    
    if browse_menu == 1
        change_game_attribute(searched_game, searched_game.name, "Title")
        #adjust name
    elsif browse_menu == 2
        change_game_attribute(searched_game, searched_game.platform, "Platform")
        #adjust platform    
    elsif browse_menu == 3
        change_game_attribute(searched_game, searched_game.genre, "Genre")
        #adjust genre  
    elsif browse_menu == 4
        change_game_attribute(searched_game, searched_game.rating, "Rating")
        #adjust rating    

    elsif browse_menu == 5
        change_game_attribute(searched_game, searched_game.game_description, "Game Description")
    elsif browse_menu == 6
        change_game_attribute(searched_game, searched_game.stock, "Stock")
    elsif browse_menu == 7
        puts "!!! Are you sure you want to remove all copies of < #{searched_game.name} >???"
        verify_choice = prompt.select("Choose one:") do |menu|
            #menu.enum '.'
            menu.choice 'Yes', 1
            menu.choice 'No', 2    
        end
        if verify_choice == 2
            return admin_games_menu
        else
        searched_game.destroy
        puts " \n < #{searched_game.name} > has been removed from your inventory"
        print "press any key to return to main menu"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        admin_menu
        end
    elsif browse_menu == 8
        admin_games_menu
    end
end

def change_game_attribute(searched_game, thing_to_change, string_to_change)
    prompt = TTY::Prompt.new

    name_in =prompt.ask("What is the new #{string_to_change}?")
        puts "!!! Do you want to change the #{string_to_change} !!! \n  from <#{thing_to_change}> \n    to <#{name_in}> ???"
        verify_choice = prompt.select("Choose one:") do |menu|
            #menu.enum '.'
            menu.choice 'Yes', 1
            menu.choice 'No', 2    
        end
        if verify_choice == 2
            return admin_games_menu
        else
            puts `clear`
            puts"!!! You have changed the #{string_to_change} !!! \n  from <#{thing_to_change}> \n    to <#{name_in}>"
            # binding.pry
            if string_to_change == "Title"
                searched_game.name = name_in
            elsif string_to_change == "Platform"
                searched_game.platform = name_in
            elsif string_to_change == "Genre"
                searched_game.genre = name_in
            elsif string_to_change == "Rating"
                searched_game.rating= name_in 
            elsif string_to_change == "Stock"
                searched_game.stock= name_in 
            else
                searched_game.game_description = name_in
            end
            searched_game.save
            print "press any key to return to main menu"                                                                                                    
            STDIN.getch                                                                                                              
            print "  \r" 
            admin_menu
        
        end
         
end




def add_game
    prompt = TTY::Prompt.new
    title = prompt.ask("What is the new game title?") 
    platform = prompt.ask("What is the new game platform?")
    genre = prompt.ask("What is the new game genre?")
    rating = prompt.ask("What is the new game rating?")
    game_description = prompt.ask("What is the new game description?")
    inventory = prompt.ask("How many copies do you want to add?")
    puts `clear`
    puts title
    puts platform
    puts genre
    puts rating
    puts game_description
    puts "Stock: #{inventory}"
    puts " "
    verify_choice = prompt.select("Are you sure you want to add this game?") do |menu|
        #menu.enum '.'
        menu.choice 'Yes', 1
        menu.choice 'No', 2    
    end
    if verify_choice == 2
        return admin_games_menu
    else
        Game.create(name: title, platform: platform, genre: genre, rating: rating, game_description: game_description, stock: inventory)
        puts `clear`
        puts title
        puts platform
        puts genre
        puts rating
        puts game_description
        puts " \n This game has been added"
        print "press any key to return to main menu"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        admin_menu
    end
end


def admin_users_menu
    prompt = TTY::Prompt.new

    admin_users_m = prompt.select("Please Select from the menu below:") do |menu|
        #menu.enum '.'
        menu.choice 'View All Users', 1
        menu.choice 'Disable / Enable User Account', 2
        menu.choice 'Go Back', 3
    end
    if admin_users_m == 1
        view_all_users
    elsif admin_users_m == 2
        disable_enable_account
    elsif admin_users_m == 3
        admin_menu
    end
end

def view_all_users
    prompt = TTY::Prompt.new 
    # user = User.all.map{|user| "#{user.id} - #{user.name} - #{user.age} - #{user.type}"}.sort 
    # user_m = prompt.select("Search for User", user, filter: true)
    headers = ["Username", "Age", "User Type"]
    rows = User.all.map { |h| [h.name, h.age, h.user_type]}
    table = TTY::Table.new headers, rows
    renderer = TTY::Table::Renderer::Unicode.new(table)
    puts renderer.render
    print "press any key to return to main menu"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r" 
    admin_menu


end

def disable_enable_account
    prompt = TTY::Prompt.new 
    user = User.all.map{|user| "#{user.id} - #{user.name} - #{user.age} - #{user.user_type}"}.sort 
    user_m = prompt.select("Search for User to disable / enable account", user, filter: true)
    #disabled account is user.user_type = 9
    data = user_m.split(" - ")
    searched_user = User.all.find{|user| user.id == data[0].to_i} 

    verify_choice = prompt.select("What do you want to do to this account? ") do |menu|
        #menu.enum '.'
        menu.choice 'Disable', 1
        menu.choice 'Enable', 2 
        menu.choice 'Go Back',3
    end
    if verify_choice == 3
        return admin_games_menu
    elsif verify_choice == 1
        searched_user.user_type = 9
        searched_user.save
        puts "  #{data[1]}  <-- This account has been disabled"
        print "press any key to return to main menu"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        admin_menu
    elsif verify_choice == 2
        searched_user.user_type = 2
        searched_user.save
        puts "  #{data[1]}  <-- This account has been enabled"
        print "press any key to return to main menu"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        admin_menu
    end

end


def admin_checkouts_menu
    prompt = TTY::Prompt.new

    admin_checkouts_m = prompt.select("Please Select from the menu below:") do |menu|
        #menu.enum '.'
        menu.choice 'View Active Checkouts', 1
        menu.choice 'View User Checkout History', 2
        menu.choice 'View All Checkout History', 3
        menu.choice 'Go Back', 4
    end

    if admin_checkouts_m == 1 
        admin_view_active_checkouts
    elsif admin_checkouts_m == 2
        admin_view_user_checkouts
    elsif admin_checkouts_m == 3
        admin_view_all_checkouts
    elsif admin_checkouts_m == 4
        admin_menu
    end
end

def admin_view_active_checkouts
    vh = []
    vh = Checkout.all.select{ |ch| ch.return_date == nil}
    headers = ["User", "Game", "Platform", "Checkout_date", "Return_date"]
    rows = vh.map { |h| [h.user.name, h.game.name, h.game.platform, h.checkout_date, h.return_date]}
    table = TTY::Table.new headers, rows
    renderer = TTY::Table::Renderer::Unicode.new(table)
    puts renderer.render
    print "press any key to return to main menu"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r" 
    admin_menu
end

def admin_view_user_checkouts
    prompt = TTY::Prompt.new 
    user = User.all.map{|user| "#{user.id} - #{user.name} - #{user.age} - #{user.user_type}"}.sort 
    user_m = prompt.select("Search for User to view Checkout history:", user, filter: true)
    data = user_m.split(" - ")
    searched_user = User.all.find{|user| user.name == data[1]}
    vh = []
    vh = Checkout.all.select{ |ch| ch.user_id == searched_user.id}
    headers = ["Game", "Platform", "Checkout_date", "Return_date"]
    rows = vh.map { |h| [h.game.name, h.game.platform, h.checkout_date, h.return_date]}
    table = TTY::Table.new headers, rows
    renderer = TTY::Table::Renderer::Unicode.new(table)
    puts renderer.render
    print "press any key to return to main menu"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r" 
    main_menu

end

def admin_view_all_checkouts
    headers = ["User", "Game", "Platform", "Checkout_date", "Return_date"]
    rows = Checkout.all.map { |h| [h.user.name, h.game.name, h.game.platform, h.checkout_date, h.return_date]}
    table = TTY::Table.new headers, rows
    renderer = TTY::Table::Renderer::Unicode.new(table)
    puts renderer.render
    print "press any key to return to main menu"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r" 
    admin_menu
end




