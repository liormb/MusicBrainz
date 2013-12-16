require 'bundler/setup'
Bundler.require(:default)

require 'pry'
require 'json'
require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'musicbrainz'
require 'wikipedia'

require_relative 'models/mbrainz'
require_relative 'models/countries'

before do
	MBrainz.init
end

get "/" do
	@main_page = true
  erb :index
end

post "/" do
	redirect "/search/#{URI.escape(params[:search])}"
end

get "/search/:search" do
  name   = params[:search].chomp
  @names = MBrainz.basic_name_search(name)
  redirect '/' if @names.nil?
  erb :index
end

get "/:name/:mbid" do
	@mbid = params[:mbid]
	@name = params[:name]
	@artist_information = MBrainz.artict_information(@mbid, @name)
	erb :artist
end