require 'sinatra' 
require 'sinatra/reloader' # to not need to reload the server when the file is changed

# class variable to track quantity of guesses taken
@@num_guesses = 5

# select random number between 0 and 100 (exclusive)
@@secret_number = rand(100) 

# define color constants
BRIGHT_RED = "#ff0000"
LIGHT_RED = "#fc8a8a"
GREEN = "#00ff00"

def check_guess(guess)

	# return an empty string if the user has not provided any input
	return '' if guess.to_s.empty?

	# one less remaining guess
	@@num_guesses = @@num_guesses - 1

	guess = guess.to_i

	if guess == @@secret_number
		message = "You have guessed correctly. The SECRET NUMBER is #{@@secret_number}."
		background_color = GREEN
	elsif guess > @@secret_number
		message = "Too high!"
		background_color = LIGHT_RED
	elsif guess < @@secret_number
		message = "Too low!"
		background_color = LIGHT_RED
	end

	# if the difference between the guess and the number is greater than five in absolute value
	if (guess - @@secret_number).abs > 5
		message = "Way t" + message[1..-1] 
		background_color = BRIGHT_RED
	end

	# if the user guessed wrong and his guesses are over
	if guess != @@secret_number && @@num_guesses == 0
		message = message + " You have lost."
	end

	# if the user guessed right or if his guesses are over
	if guess == @@secret_number || @@num_guesses == 0
		message = message + " A new number has been generated."
		@@num_guesses = 5
		@@secret_number = rand(100)
	end

	return [message, background_color]
end


get '/' do
	guess = params["guess"]
	cheat = params["cheat"]
	# message displayed if user has manually set cheat mode and hasn't guessed it right
	clue = "The SECRET NUMBER is #{@@secret_number}." if cheat.to_s == "true" && guess != @@secret_number.to_s
	result = check_guess(guess)
	message = result[0]
	background_color = result[1]
	num = result[2]
	erb :index, :locals => {:message => message, :background_color => background_color, :clue => clue, :guesses => @@num_guesses}
end