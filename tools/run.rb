require_relative '../config/environment.rb'
prompt = TTY::Prompt.new


def start_here
    puts `clear`
    welcome_message
    welcome_menu
end

def exit
    puts `clear`
    puts "Thanks for choosing the Compendium!"
    puts "See you soon!"
    puts
    puts
end

def welcome_message
    
    puts "   ██████╗ ██████╗ ███╗   ███╗██████╗ ███████╗███╗   ██╗██████╗ ██╗██╗   ██╗███╗   ███╗ "
    puts "  ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔════╝████╗  ██║██╔══██╗██║██║   ██║████╗ ████║ "
    puts "  ██║     ██║   ██║██╔████╔██║██████╔╝█████╗  ██╔██╗ ██║██║  ██║██║██║   ██║██╔████╔██║ "
    puts "  ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║  ██║██║██║   ██║██║╚██╔╝██║ "
    puts "  ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗██║ ╚████║██████╔╝██║╚██████╔╝██║ ╚═╝ ██║ "
    puts "   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═══╝╚═════╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝ "
    puts "                                                                                        "
    puts "Welcome to the Compendium!"
    puts "++++++++++++++++++++++++++"
    puts " "
    puts "We are a rental service that links players to a vast library of games."
    puts ""

end

def welcome_menu
    prompt = TTY::Prompt.new

    welcome_m = prompt.select(" ") do |menu|
        #menu.enum '.'
        menu.choice 'Log In', 1
        menu.choice 'Create New User', 2
        menu.choice 'Exit', 3
    end

    if welcome_m == 1 
        login
    elsif welcome_m == 2
        create_new_user
    elsif welcome_m == 3 
        puts " "
        exit_menu= prompt.select("Are you sure you want to exit?") do |menu|
            #menu.enum '.'
            menu.choice 'Yes', 1
            menu.choice 'No', 2    
        end
        if exit_menu == 1
            exit
        elsif exit_menu == 2
            start_here
        end 
    end
end

def login
    prompt = TTY::Prompt.new

    name_in =prompt.ask("What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
    end

    name_match = User.all.find do |user|
         user.name == name_in
        
    end

    if name_match == nil
        puts "Username does not exist"
        print " ---press any key---"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        start_here
    end

    password_verify(name_match)

end

def password_verify(name_match)
    prompt = TTY::Prompt.new
    index = 0
    
    while index < 3 do
        password_in =prompt.mask("What is your password?") do |q|
            q.required true
            q.validate /\A\w+\Z/
            #q.modify   :capitalize
        end    

        if name_match.authenticate(password_in)
            puts " "
            puts "   Welcome #{name_match.name}"
            puts " ---press any key---"                                                                                                    
            STDIN.getch                                                                                                              
            print "  \r" 
            @user = name_match
            return main_menu
        else
            puts " "
            puts "Incorrect Password"
        end
        index += 1
        puts "Try again. You have #{3-index} tries left" 
    end
    puts " "
    puts "Returning to start screen "
    puts " ---press any key---"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r" 
    start_here
end



def create_new_user
    prompt = TTY::Prompt.new

    name_in =prompt.ask("What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
    end

    x = User.all.find do |u|
        name_in == u.name
    end

    if x != nil
        puts " "
        puts "Username already exists."
        print "press any key"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        return start_here
    end


    create_new_password(name_in)
end

def create_new_password(name_in)
    prompt = TTY::Prompt.new

    password_in =prompt.mask("What is your password?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        #q.modify   :capitalize
     end

    password_verify =prompt.mask("Please verify your password:") do |q|
        q.required true
        q.validate /\A\w+\Z/
        #q.modify   :capitalize
    end

    if password_in != password_verify
        puts "Passwords do not match!"
        puts "Please try again."      
        return create_new_password(name_in)
    else
        age =prompt.ask("How old are you?") do |q|
            q.required true
            q.validate /\A\w+\Z/
            #q.modify   :capitalize
        end
        User.create(name: name_in, password: password_in, age: age)
        puts " "
        puts "New user sucessfully created!"
        print "press any key"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        main_menu
    end
end

def main_menu
    prompt = TTY::Prompt.new

    puts `clear`
    welcome_message 

    main_m = prompt.select(" ") do |menu|
        #menu.enum '.'
        menu.choice 'Browse Games', 1
        menu.choice 'Return Game', 2
        menu.choice 'View History', 3
        menu.choice 'Exit', 4
    end

    if main_m == 1
        browse_games
    

    elsif main_m == 2
        #return_game
    

    elsif main_m == 3
        #view_history
    

    elsif main_m == 4
        puts " "
        exit_menu = prompt.select("Are you sure you want to exit?") do |menu|
            #menu.enum '.'
            menu.choice 'Yes', 1
            menu.choice 'No', 2    
        end
        if exit_menu == 1
            exit
        elsif exit_menu == 2
            main_menu
        end 
    end
end

def browse_games
    prompt = TTY::Prompt.new

    browse_menu = prompt.select("Choose an option:") do |menu|
        #menu.enum '.'
        menu.choice 'Search game by title', 1
        menu.choice 'Search games by genre', 2  
        menu.choice 'Search games by platform', 3
        menu.choice 'Search games by rating', 4
        menu.choice 'List all game A-Z', 5 
        menu.choice 'List available games', 6
        menu.choice 'Return to Main Menu', 7   
    end

    if browse_menu == 1
        title_search
    
    elsif browse_menu == 2
        genre_search
    
    elsif browse_menu == 3
        platform_search
    
    elsif browse_menu == 4
        rating_search
    
    elsif browse_menu == 5
        list_all_games
    
    elsif browse_menu == 6 
        list_available_games
    
    elsif browse_menu == 5
        main_menu
    end 

end

def checkout_game

end

def reserve_game

end

def return_game

end

def view_history

end

def title_search
    prompt = TTY::Prompt.new 
    games = Game.all.map{|game| "#{game.name} - #{game.platform}"}.sort 
    games_m = prompt.select("Search for title", games, filter: true)
    game_info(games_m)
end

def genre_search
    prompt = TTY::Prompt.new
    game_genre = Game.all.map{|game| "#{game.genre}"}.uniq.sort 
    game_genre_m = prompt.select("Choose a genre", game_genre, filter: true)
    games_by_genre(game_genre_m)
end

def games_by_genre(selected_category)
    prompt = TTY::Prompt.new
    games_by_genre = Game.all.select{|game| game.genre == selected_category}
    games_by_genre_name = games_by_genre.map{|game| "#{game.name} - #{game.platform}"}.sort
    games_by_genre_m = prompt.select("Choose a game", games_by_genre_name, filter: true)
    game_info(games_by_genre_m)
end

def platform_search
    prompt = TTY::Prompt.new
    game_platform = Game.all.map{|game| "#{game.platform}"}.uniq.sort
    game_platform_m = prompt.select("Choose a platform", game_platform, filter: true)
    games_by_platform(game_platform_m)
end

def games_by_platform(selected_category)
    prompt = TTY::Prompt.new
    gbp = Game.all.select{|game| game.platform == selected_category}
    gbpn = gbp.map{|game| "#{game.name} - #{game.platform}"}.sort 
    gbpn_m = prompt.select("Choose a game", gbpn, filter: true)
    game_info(gbpn_m)
end

def rating_search
    prompt = TTY::Prompt.new
    game_rating = Game.all.map{|game| "#{game.rating}"}.uniq.sort
    game_rating_m = prompt.select("Choose a rating", game_rating, filter: true)
    games_by_rating(game_rating_m)
end

def games_by_rating(selected_category)
    prompt = TTY::Prompt.new
    gbr = Game.all.select{|game| game.rating == selected_category}
    gbrn = gbr.map{|game| "#{game.name} - #{game.platform}"}.sort
    gbrn_m = prompt.select("Choose a game", gbrn, filter: true)
    game_info(gbrn_m)
end

def list_all_games
    prompt = TTY::Prompt.new
    all_games = Game.all.map{|game| "#{game.name} - #{game.platform}"}.sort
    all_games_m  = prompt.select("Choose a game", all_games, filter: true)
    game_info(all_games_m)
end

def list_available_games
    prompt = TTY::Prompt.new
    in_stock = Game.all.select{|game| game.stock > 0}
    in_stock_games = in_stock.map{|game| "#{game.name} - #{game.platform}"}.sort
    in_stock_games_m = prompt.select("Choose a game", in_stock_games, filter: true)
    game_info(in_stock_games_m)
end

def game_info(selected_game)
    prompt = TTY::Prompt.new
    data = selected_game.split(" - ")
    searched_game = Game.all.find{|game| game.name == data[0]}
    puts searched_game.name
    puts searched_game.platform
    puts searched_game.genre
    puts searched_game.rating
    puts searched_game.game_description
    browse_menu = prompt.select("Choose an option:") do |menu|
        #menu.enum '.'
        menu.choice 'Checkout Game', 1
        menu.choice 'Reserve Game', 2
        menu.choice 'Browse Games', 3
    end

    if browse_menu == 1
        checkout_game
    elsif browse_menu == 2
        reserve_game    
    elsif browse_menu == 3
        browse_games
    end
end








start_here