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

get '/' do
	redirect '/actors'
end

get '/actors' do
	sql = "SELECT name, id FROM actors AS actor_list;"
	@actors_array = []
	
	db_connection do |conn|
	  actor = conn.exec(sql)
	  actor.each do |actors_name|
	  	@actors_array << actors_name
	  end
	  erb :'actors/index'
	end
end

get '/actors/:id' do
	sql = "
	SELECT actors.name, movies.title, cast_members.character, actors.id 
	FROM actors 
	JOIN cast_members ON actors.id = cast_members.actor_id 
	JOIN movies ON movies.id = cast_members.movie_id 
	WHERE actors.id = #{params["id"]} 
	ORDER BY name;"

	db_connection do |conn|
  	@actor = conn.exec(sql)
  end
	erb :'actors/show'
end

get '/movies' do 
	sql = "SELECT title FROM movies AS movie_list;"
	@movie_array = []
	
	db_connection do |conn|
	  movie = conn.exec(sql)
	  movie.each do |movie_name|
	  	binding.pry
	  	@movie_array << movie_name
	  end
	  erb :'movies/index'
	end
end
