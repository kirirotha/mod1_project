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

    password_in =prompt.mask("What is your password?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
    end

    main_menu
end


def create_new_user
    prompt = TTY::Prompt.new

    name_in =prompt.ask("What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
    end

    create_new_password
end

def create_new_password
    prompt = TTY::Prompt.new

    password_in =prompt.mask("What is your password?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
     end

     password_verify =prompt.mask("Please verify your password:") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
     end

    if password_in != password_verify
        puts "Passwords do not match!"      
        create_new_password
    else
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
        menu.choice 'List all games A-Z', 3
        menu.choice 'List available games', 4
        menu.choice 'Return to Main Menu', 5    
    end

    if browse_menu == 1
        title_search

    elsif browse_menu == 2
        genre_search

    elsif browse_menu == 3
        list_all_games

    elsif browse_menu == 4 
        list_available_games

    elsif browse_menu == 5
        main_menu
    end 

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
        menu.choice 'Previous Menu', 3
    end

    if browse_menu == 3
        browse_games
    end
end








start_here