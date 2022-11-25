require 'sinatra'               # to get the POST request
require 'sinatra/reloader'      # reload the server without restarting it
require 'sinatra/static_assets' # show static images
require 'json'                  # parse JSON
require 'httparty'              # go tothe artifacts_url and download the artifact
require 'dotenv'                # load the .env file

require_relative 'webhook.rb'

# load the environment file containing secret variables
Dotenv.load('../../.env_prd')

# needed for sinatra to work properly in my local environment
set :bind, '0.0.0.0'
#set :public_folder, ENV['FOLDER']

# --------------------------------------- #
#                  routes                 #
# --------------------------------------- #

post '/github/GBA_Pong_webhook' do
  getpayload('GBA_Pong/')
end

get '/github/GBA_Pong_webhook' do
  'Nothing here'
end

post '/github/GBA_Pong_butano_edition_webhook' do
  getpayload('GBA_Pong_butano_edition/')
end

get '/github/GBA_Pong_butano_edition_webhook' do
  'Nothing here'
end

get '/github/GBA_Pong/' do
  # we only want to show the zip files
  @files_full = Dir.glob('GBA_Pong/'+'*.zip')

  @file_sizes   = @files_full.map { |file| "#{(File.size(file)/1024.0).round(2)} KB" }
  @file_names   = @files_full.map { |file| File.basename(file) }
  @upload_dates = @files_full.map { |file| File.mtime(file)}

  erb :files
end

get '/github/GBA_Pong/:filename' do |filename|
  send_file "#{'GBA_Pong/'}#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

get '/github/GBA_Pong_butano_edition/' do
  # we only want to show the zip files
  @files_full = Dir.glob('GBA_Pong_butano_edition/'+'*.zip')

  @file_sizes   = @files_full.map { |file| "#{(File.size(file)/1024.0).round(2)} KB" }
  @file_names   = @files_full.map { |file| File.basename(file) }
  @upload_dates = @files_full.map { |file| File.mtime(file)}

  erb :files
end

get '/github/GBA_Pong_butano_edition/:filename' do |filename|
  send_file "#{'GBA_Pong_butano_edition/'}#{filename}", :filename => filename, :type => 'Application/octet-stream'
end
