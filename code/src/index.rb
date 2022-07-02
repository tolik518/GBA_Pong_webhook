require 'sinatra'         # to get the POST request
require 'sinatra/reloader'# reload the server without restarting it
require 'json'            # parse JSON
require 'httparty'        # go tothe artifacts_url and download the artifact
require 'dotenv'          # load the .env file

require_relative 'webhook.rb'

# load the environment file containing secret variables
Dotenv.load("../../.env_prd")

# needed for sinatra to work properly in my local environment
set :bind, '0.0.0.0'
set :public_folder, ENV['FOLDER']

# --------------------------------------- #
#                  routes                 #
# --------------------------------------- #

post '/github/GBA_Pong_webhook' do
    getpayload
end

get '/github/GBA_Pong_webhook' do
    "Is this thing on?"
end

get '/github/GBA_Pong' do
    @files_full = Dir.glob(ENV['FOLDER']+"*.zip")

    @file_sizes   = @files_full.map { |file| "#{(File.size(file)/1024.0).round(2)} KB" }
    @file_names   = @files_full.map { |file| File.basename(file) }
    @upload_dates = @files_full.map { |file| File.mtime(file)}

    erb :files
end

get '/github/GBA_Pong/:filename' do |filename|
    send_file "#{ENV['FOLDER']}#{filename}", :filename => filename, :type => 'Application/octet-stream'
end