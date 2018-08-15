require 'sinatra'
require 'sinatra/reloader'

SECRET_NUMBER = rand(100)
set :number, SECRET_NUMBER

def check_guess(guess)
	return '' if guess.to_s.empty?
	guess = guess.to_i
	appendix = "Way t"
	if guess > settings.number
		message = "Too high!"
		message = appendix + message[1..-1] if guess > settings.number + 5
	elsif guess < settings.number
		message = "Too low!"
		message = appendix + message[1..-1] if guess < settings.number - 5
	end
	return message
end

get '/' do
	guess = params["guess"]
	message = check_guess(guess)
	erb :index, :locals => {:message => message}
end