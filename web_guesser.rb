require 'sinatra' 
require 'sinatra/reloader' # to not need to reload the server when the file is changed

# select random number between 0 and 100 (exclusive)
SECRET_NUMBER = rand(100) 

# Sinatra's settings feature
set :number, SECRET_NUMBER 

# define color constants
BRIGHT_RED = "#ff0000"
LIGHT_RED = "#fc8a8a"
GREEN = "#00ff00"

def check_guess(guess)
	# return an empty string if the user has not provided any input
	return '' if guess.to_s.empty? 

	guess = guess.to_i

	# the values if the guess is right
	message = "The SECRET NUMBER is #{settings.number}"
	background_color = GREEN

	if guess > settings.number
		message = "Too high!"
		background_color = LIGHT_RED
	elsif guess < settings.number
		message = "Too low!"
		background_color = LIGHT_RED
	end

	if (guess - settings.number).abs > 5
		message = "Way t" + message[1..-1] 
		background_color = BRIGHT_RED
	end

	return [message, background_color]
end

get '/' do
	guess = params["guess"]
	cheat = params["cheat"]
	clue = "The SECRET NUMBER is #{settings.number}" if cheat.to_s == "true" && guess != settings.number.to_s
	result = check_guess(guess)
	message = result[0]
	background_color = result[1]
	erb :index, :locals => {:message => message, :background_color => background_color, :clue => clue}
end