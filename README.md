
The Compendium!
A service that links players to our vast library of games, allowing them to check out and play multiple titles by subscribing to our service! 


Models
Player
	A player can checkout many times
	A player has access to many games through checkout
Games
	A game can be checked out many times
	A game has many players through checkout
Checkout!
	Checkout links a player to a game
	This provides a clear relationship between players and their games


MVP Goals
	A player can log in and look at past checkouts
	A player can browse the library and add games to their cart
	A player can checkout a game
	The game library updates available stock based on checkouts
	Checkout provides players with the amount of money they’ve saved that month
Stretch Goals
	Set up a premium membership that allows a player to checkout multiple games
	Provide recommendations on new games based on previous checkouts
	Allows a player to sell their games to the library
	Allows a player to set up a queue of games to checkout if they are unavailable.
    Reccomend games to user
    Rating system
    


Variables

Player
-username
-password
-age


Games
-name
-platform
-genre
-game description
-In-Stock?


Checkout
-user_id
-game_id
-rating
-comment/review








