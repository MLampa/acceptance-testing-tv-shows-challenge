require 'sinatra'
require 'csv'
require_relative "app/models/television_show"
require 'pry'

set :views, File.join(File.dirname(__FILE__), "app/views")

get '/television_shows' do
  @tv_shows = []
  CSV.foreach('television-shows.csv', headers: true, header_converters: :symbol) do |row|
    show = row.to_hash
    @tv_shows << show
  end
  erb :index
end

get '/television_shows/new' do
  erb :new
end

post '/television_shows' do
  title = params[:title]
  network = params[:network]
  starting_year = params[:starting_year]
  synopsis = params[:synopsis]
  genre = params[:genre]

  show_array = [title, network, starting_year, synopsis, genre]

  @error = nil

  if title.empty? || network.empty? || starting_year.empty? || synopsis.empty? || genre.empty?
    @error = "Please fill in all required fields"
  else
    CSV.foreach("television-shows.csv") do |show|
      if show.first == title
        @error = "The show has already been added"
      end
    end
  end

  unless @error
    CSV.open("television-shows.csv", 'a') { |file| file << show_array }
    redirect '/television_shows'
  end

  erb :new
end
