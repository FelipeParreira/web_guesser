require 'sinatra'
require 'sinatra/reloader'

secret_number = rand(101)
get '/' do
	"The SECRET NUMBER is #{secret_number}"
end