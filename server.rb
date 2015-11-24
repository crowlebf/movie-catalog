require "sinatra"
require "pg"
require 'pry'
require 'tilt/erubis'

set :views, File.join(File.dirname(__FILE__), "app/views")

configure :development do
  set :db_config, { dbname: "movies" }
end

configure :test do
  set :db_config, { dbname: "movies_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

get '/actors' do
	# @actors_array = []
	# db_connection do |conn|
	#   name = conn.exec("SELECT name, id FROM actors AS actor_list;")
	#   # binding.pry
	#   name.each do |actors_name|
	#   	# binding.pry
	#   	@actors_array << actors_name	  	
	#   	erb :'actors/index'
	#   end
	# end
end

get '/actors/:id' do
end
