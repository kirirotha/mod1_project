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
    puts "Welcome to the Compendium!"
    puts "++++++++++++++++++++++++++"
    puts " "
    puts "We are a rental service that links players to a vast library of games."
    puts ""

end

def welcome_menu
    prompt = TTY::Prompt.new

    x= prompt.select(" ") do |menu|
        menu.enum '.'
        menu.choice 'Log In', 1
        menu.choice 'Create New User', 2
        menu.choice 'Exit', 3
    end

    if x == 1 
        login
    elsif x == 2
        create_new_user
    elsif x == 3 
        y= prompt.select("Are you sure you want to exit?") do |menu|
            menu.enum '.'
            menu.choice 'Yes', 1
            menu.choice 'No', 2    
        end
        if y == 1
            exit
        elsif y==2
            run_this
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
        puts "New user sucessfully created!"
        main_menu
    end
end

def main_menu
    prompt = TTY::Prompt.new

    puts `clear`
    welcome_message 

    x= prompt.select(" ") do |menu|
        menu.enum '.'
        menu.choice 'Browse Games', 1
        menu.choice 'Return Game', 2
        menu.choice 'View History', 3
        menu.choice 'Exit', 4
    end

    if x == 1
        browse_games
    

    elsif x == 2
        #return_game
    

    elsif x == 3
        #view_history
    

    elsif x == 4
        y= prompt.select("Are you sure you want to exit?") do |menu|
            menu.enum '.'
            menu.choice 'Yes', 1
            menu.choice 'No', 2    
        end
        if y == 1
            exit
        elsif y==2
            main_menu
        end 
    end
end

def browse_games
    browse_in = prompt.select("Choose an option:") do |menu|
        menu.enum '.'
        menu.choice 'Search all games by title', 1
        menu.choice 'Search by games by genre', 2  
        menu.choice 'List all games A-Z', 3
        menu.choice 'List available games', 4
        menu.choice 'Return to Main Menu', 5    
    end

    if browse_in == 1
        #title_search

    elsif y==2
        #genre_search

    elsif y==3
        #list_all_games

    elsif y==4
        #list_available_games

    elsif y==5
        main_menu
    end 

end

def return_game

end

def view_history

end

def title_search

end

def genre_search

end

def list_all_games

end

def list_available_games

end









start_here