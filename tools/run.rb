require_relative '../config/environment.rb'
require_relative '../app/admin.rb'
require 'date'


def start_here
    puts `clear`
    welcome_message
    welcome_menu
end

def exit
    puts `clear`
    compendium_image
    puts "\n Thanks for choosing the Compendium!"
    puts "\n See you soon!"
    puts
    puts
end

def compendium_image
    box = TTY::Box.frame(width: 100, height: 14, align: :center, padding: 3,
    style: {fg: :black,bg: :green,
    border: {fg: :black,bg: :green}}) do    
" ██████╗ ██████╗ ███╗   ███╗██████╗ ███████╗███╗   ██╗██████╗ ██╗██╗   ██╗███╗   ███╗
██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔════╝████╗  ██║██╔══██╗██║██║   ██║████╗ ████║ 
██║     ██║   ██║██╔████╔██║██████╔╝█████╗  ██╔██╗ ██║██║  ██║██║██║   ██║██╔████╔██║ 
██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║  ██║██║██║   ██║██║╚██╔╝██║ 
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗██║ ╚████║██████╔╝██║╚██████╔╝██║ ╚═╝ ██║ 
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═══╝╚═════╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝ 
"                                                                                        

    end
    puts box
    puts " "
end

def welcome_message
    puts `clear`
    compendium_image
    puts "\n Welcome to the Compendium!"
    puts " ++++++++++++++++++++++++++"
    puts " "
    puts " We are a rental service that links players to a vast library of games."
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
        exit_menu= prompt.select(" Are you sure you want to exit?") do |menu|
            #menu.enum '.'
            menu.choice ' Yes', 1
            menu.choice ' No', 2    
        end
        if exit_menu == 1
            exit
        elsif exit_menu == 2
            start_here
        end 
    end
end

def wrap(s, width=55)
    s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
end
  

def login
    prompt = TTY::Prompt.new

    name_in =prompt.ask("  What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
    end

    name_match = User.all.find do |user|
         user.name == name_in
        
    end

    if name_match == nil
        puts "\n Username does not exist!!!"
        print "\n  ---press any key---\n"                                                                                                    
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
        password_in =prompt.mask("  What is your password?") do |q|
            q.required true
            q.validate /\A\w+\Z/
            #q.modify   :capitalize
        end    

        if name_match.authenticate(password_in)
            puts " "
            puts "  Welcome #{name_match.name}"
            puts "\n  ---press any key---\n"                                                                                                    
            STDIN.getch                                                                                                              
            print "  \r" 
            @user = name_match
            index = 3
            if @user.user_type == 1
                return admin_menu

            elsif
                @user.user_type == 9
                puts "\n  Your account has been disabled."
                puts "\n  ---press any key---\n"                                                                                                    
                STDIN.getch                                                                                                              
                print "  \r" 
                return start_here
            end
            return main_menu
        else
            puts " "
            puts "  Incorrect Password\n"
        end
        index += 1
        puts "  Try again. You have #{3-index} tries left" 
    end
    puts " "
    puts "\n  Returning to start screen "
    puts "\n   ---press any key---\n"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r" 
    start_here
end



def create_new_user
    prompt = TTY::Prompt.new
    welcome_message
    name_in =prompt.ask("  What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
    end

    x = User.all.find do |u|
        name_in == u.name
    end

    if x != nil
        puts " "
        puts "  Username already exists."
        print "\n ---press any key---\n"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        return start_here
    end


    create_new_password(name_in)
end

def create_new_password(name_in)
    prompt = TTY::Prompt.new

    password_in =prompt.mask("  What is your password?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        #q.modify   :capitalize
     end

    password_verifying =prompt.mask("  Please verify your password:") do |q|
        q.required true
        q.validate /\A\w+\Z/
        #q.modify   :capitalize
    end

    if password_in != password_verifying
        puts "\n  Passwords do not match!"
        puts "  Please try again."      
        return create_new_password(name_in)
    else
        age =prompt.ask("  How old are you?") do |q|
            q.required true
            q.validate /\A\w+\Z/
            #q.modify   :capitalize
        end
        email =prompt.ask("  What is your email address?") do |q|
            q.required true
            #q.validate /\A\w+\Z\@/
            #q.modify   :capitalize
        end
        @user = User.create(name: name_in, password: password_in, age: age, user_type: 2, email: email)
        puts " "
        puts "  New user sucessfully created!"
        print "\n  ---press any key---\n"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        return main_menu
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
        return_game
    

    elsif main_m == 3
        view_history
    

    elsif main_m == 4
        puts " "
        exit_menu = prompt.select("  Are you sure you want to exit?") do |menu|
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

    browse_menu = prompt.select("  Choose an option:") do |menu|
        #menu.enum '.'
        menu.choice 'Search games by title', 1
        menu.choice 'Search games by genre', 2  
        menu.choice 'Search games by platform', 3
        menu.choice 'Search games by rating', 4
        menu.choice 'List all games A-Z', 5 
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
    
    elsif browse_menu == 7
        main_menu
    end 

end

def checkout_game(searched_game)
    prompt = TTY::Prompt.new
    
    cc = Checkout.new(user_id: @user.id, game_id: searched_game.id)
    browse_menu = prompt.select("  Do you want to checkout #{searched_game.name}?") do |menu|
        #menu.enum '.'
        menu.choice 'Yes', 1
        menu.choice 'Browse more games', 2  
    end

    if browse_menu == 1
        cc.checkout_date = DateTime.now
        cc.save
        searched_game.stock -= 1
        searched_game.save
        puts " "
        puts "  You have checked out #{searched_game.name}."
        print "\n ---press any key---\n"                                                                                                    
        STDIN.getch                                                                                                              
        print "  \r" 
        main_menu
    elsif browse_menu == 2
        browse_games    
    end
    
end

def reserve_game

end

def return_game
    prompt = TTY::Prompt.new
    games_out = Checkout.all.select{ |ch| ch.user_id == @user.id && ch.return_date == nil}
    checkout_list = games_out.map{|chckout| "#{chckout.game.name} - #{chckout.game.platform}"}.sort
    checkout_list << "Go Back"
    return_this_game = prompt.select("Choose a game to return:", checkout_list)
    if return_this_game == "Go Back"
        return main_menu
    end
    process_return(return_this_game)
end

def process_return(return_this_game)
    prompt = TTY::Prompt.new

    data = return_this_game.split(" - ")
    returned_game = Game.all.find{|game| game.name == data[0] && game.platform == data[1]}
    returned_game.stock += 1
    returned_game.save
    games_out = Checkout.all.select{ |ch| ch.user_id == @user.id && ch.return_date == nil}
    return_this = games_out.find{ |chkout| chkout.game.name == data[0] && chkout.game.platform == data[1]}
    return_this.return_date = DateTime.now
    user_rating =prompt.ask("Please rate this game:") do |q|
        q.required true
        q.in("0-10") 
        q.modify   :capitalize
    end
    want_to_comment = prompt.select("Do you want to leave a comment?") do |menu|
        #menu.enum '.'
        menu.choice 'Yes', 1
        menu.choice 'No', 2  
    end
    if want_to_comment == 1
        comment =prompt.ask("Please write a comment about this game:") do |q|
            q.required true
            q.modify   :capitalize
        end
    end
    return_this.rating = user_rating
    return_this.comment = comment
    return_this.save
    main_menu
end



def view_history
    vh = []
    vh = Checkout.all.select{ |ch| ch.user_id == @user.id}
    headers = ["Game", "Platform", "Checkout_date", "Return_date"]
    rows = vh.map { |h| [h.game.name, h.game.platform, h.checkout_date, h.return_date]}
    table = TTY::Table.new headers, rows
    renderer = TTY::Table::Renderer::Unicode.new(table)
    puts renderer.render
    print "\n  ---press any key to return to main menu---\n"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r" 
    main_menu
end

def title_search
    prompt = TTY::Prompt.new 
    puts `clear`
    compendium_image
    puts ""
    games = Game.all.map{|game| "#{game.name} - #{game.platform}"}.sort 
    games.unshift("Go Back")
    games_m = prompt.select("Search for title", games, filter: true)
    if games_m == "Go Back"
        browse_games
    else
        game_info(games_m)
    end
end

def genre_search
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    game_genre = Game.all.map{|game| "#{game.genre}"}.uniq.sort
    game_genre.unshift("Go Back") 
    game_genre_m = prompt.select("Choose a genre", game_genre, filter: true)
    if game_genre_m == "Go Back"
        browse_games
    else
        games_by_genre(game_genre_m)
    end
end

def games_by_genre(selected_category)
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    games_by_genre = Game.all.select{|game| game.genre == selected_category}
    games_by_genre_name = games_by_genre.map{|game| "#{game.name} - #{game.platform}"}.sort
    games_by_genre_name.unshift("Go Back")
    games_by_genre_m = prompt.select("Choose a game", games_by_genre_name, filter: true)
    if games_by_genre_m == "Go Back"
        browse_games
    else
        game_info(games_by_genre_m)
    end
end

def platform_search
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    game_platform = Game.all.map{|game| "#{game.platform}"}.uniq.sort
    game_platform.unshift("Go Back")
    game_platform_m = prompt.select("Choose a platform", game_platform, filter: true)
    if game_platform_m == "Go Back"
        browse_games
    else
        games_by_platform(game_platform_m)
    end
end

def games_by_platform(selected_category)
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    gbp = Game.all.select{|game| game.platform == selected_category}
    gbpn = gbp.map{|game| "#{game.name} - #{game.platform}"}.sort 
    gbpn_m = prompt.select("Choose a game", gbpn, filter: true)
    game_info(gbpn_m)
end

def rating_search
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    game_rating = Game.all.map{|game| "#{game.rating}"}.uniq.sort
    game_rating.unshift("Go Back")
    game_rating_m = prompt.select("Choose a rating", game_rating, filter: true)
    if game_rating_m == "Go Back"
        browse_games
    else
        games_by_rating(game_rating_m)
    end
end

def games_by_rating(selected_category)
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    gbr = Game.all.select{|game| game.rating == selected_category}
    gbrn = gbr.map{|game| "#{game.name} - #{game.platform}"}.sort
    gbrn_m = prompt.select("Choose a game", gbrn, filter: true)
    game_info(gbrn_m)
end

def list_all_games
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    all_games = Game.all.map{|game| "#{game.name} - #{game.platform}"}.sort
    all_games.unshift("Go Back")
    all_games_m  = prompt.select("Choose a game", all_games, filter: true)
    if all_games_m == "Go Back"
        browse_games
    else
        game_info(all_games_m)
    end
end 

def list_available_games
    prompt = TTY::Prompt.new
    puts `clear`
    compendium_image
    in_stock = Game.all.select{|game| game.stock > 0}
    in_stock_games = in_stock.map{|game| "#{game.name} - #{game.platform}"}.sort
    in_stock_games.unshift("Go Back")
    in_stock_games_m = prompt.select("Choose a game", in_stock_games, filter: true)
    if in_stock_games_m == "Go Back"
        browse_games
    else
        game_info(in_stock_games_m)
    end
end

def game_info(selected_game)
    prompt = TTY::Prompt.new
    pastel = Pastel.new

    puts `clear`
    compendium_image
    
    data = selected_game.split(" - ")
    searched_game = Game.all.find{|game| game.name == data[0]}
    puts pastel.red("\nTitle: ") + "#{searched_game.name}"
    puts pastel.red("\nPlatform: ") + "#{searched_game.platform}"
    puts pastel.red("\nGenre: ") + "#{searched_game.genre}"
    puts pastel.red("\nRating: ") + "#{searched_game.rating}"
    puts pastel.red("\nDescription: ") + "#{wrap(searched_game.game_description)}"
    xx = Checkout.all.select { |checkout| checkout.game_id == searched_game.id} 
    user_ratings = xx.map { |x| x.rating}
    average_rating = (user_ratings.sum / user_ratings.count.to_f).truncate(2)
    puts pastel.red("\nUser Rating: ") + "#{average_rating}"
    puts " "

    if searched_game.stock > 0 
        browse_menu = prompt.select("Choose an option:") do |menu|
            #menu.enum '.'
            menu.choice 'Checkout Game', 1
            menu.choice 'View Comments', 2
            menu.choice 'Browse Games', 3
        end
    else   
        browse_menu = prompt.select("Choose an option:") do |menu|
            #menu.enum '.'
            menu.choice 'Checkout Game', 1, disabled: "(Out of Stock)" 
            menu.choice 'View Comments', 2
            menu.choice 'Browse Games', 3
        end
    end

    if browse_menu == 1
        checkout_game(searched_game)
    elsif browse_menu == 2
        view_comments(searched_game)    
    elsif browse_menu == 3
        browse_games
    end
end

def view_comments(searched_game)
    puts `clear`
    compendium_image
    xx = Checkout.all.select { |checkout| checkout.game_id == searched_game.id} 
    user_comments = xx.map { |x| x.comment }
    actual_comments = user_comments.select {|x| x != nil}
    actual_comments.each {|x| puts "\n#{x}\n"}
    if actual_comments.count == 0
        puts "\n There are no comments for this game yet."
    end
    print "\n  ---press any key to return to game info---\n"                                                                                                    
    STDIN.getch                                                                                                              
    print "  \r"
    game_name = "#{searched_game.name} - #{searched_game.platform}"
    game_info(game_name)
    # average_rating = (user_ratings.sum / user_ratings.count.to_f).truncate(2)
end






start_here