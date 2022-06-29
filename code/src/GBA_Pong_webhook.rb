require 'sinatra'
require 'json'
require 'httparty'
require 'dotenv'

Dotenv.load(".env_prd")

set :bind, '0.0.0.0'

post '/GBA_Pong_webhook' do
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)
    json = JSON.parse(payload_body)

    is_successful = json["action"] == "completed" and json["workflow_run"]["name"] == "Compile GBA" and json["workflow_run"]["conclusion"] == "success"

    if is_successful
        response = HTTParty.get(json["workflow_run"]["artifacts_url"])
        json_af = JSON.parse(response.body)

        url        = json_af["artifacts"][0]["archive_download_url"]
        created_at = json_af["artifacts"][0]["created_at"]
        sha        = json["workflow_run"]["head_sha"]
        file_name  = ENV["FOLDER"] + created_at + "_" + sha +".zip"

        File.open(file_name, "wb") do |f| 
            f.write HTTParty.get(url,
                headers: { "Authorization" => "token " + ENV["TOKEN"] }
            ).body

            puts "Downloaded artifact"
            puts File.size(file_name)
        end
    end
end

get '/GBA_Pong_webhook' do
    "Is this thing on?"
end
  
def verify_signature(payload_body)
    signature = 'sha256=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV["SECRET"], payload_body)
    return halt 518, "Bad secret." unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE_256'])
end