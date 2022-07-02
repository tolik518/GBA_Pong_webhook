def getpayload()
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)
    json = JSON.parse(payload_body)

    workflow = json["workflow_run"]

    is_successful = (json["action"] == "completed" and workflow["name"] == "Compile GBA" and workflow["conclusion"] == "success")

    # proceed only when 'Compile GBA'-workflow was as 'success'
    if is_successful
        response = HTTParty.get(workflow["artifacts_url"])
        json_af  = JSON.parse(response.body)
        # [0] -> because we get an array of artifacts back - which consists only of one item though
        artifact = json_af["artifacts"][0]

        file_url   = artifact["archive_download_url"]
        created_at = artifact["created_at"]
        sha        = workflow["head_sha"] # this is the commit hash
        file_name  = ENV["FOLDER"] + "#{created_at}_#{sha}.zip"

        download(file_name, file_url)
    end
end

# --------------------------------------- #
#            Helper functions             #
# --------------------------------------- #

def download(file_name, file_url)
    File.open(file_name, "wb") do |f| 
        f.write HTTParty.get(
            file_url,
            # we need the auth token, otherwise we have no rights to access the artifact
            headers: { "Authorization" => "token " + ENV["TOKEN"] } 
        ).body

        file_size = File.size(file_name)/1024;

        puts "Downloaded artifact"
        puts "File size: #{file_size} KB"
    end
end
  
def verify_signature(payload_body)
    signature = 'sha256=' + OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'), 
        ENV["SECRET"], 
        payload_body
    )
    
    return halt 518, "Bad secret." unless Rack::Utils.secure_compare(
        signature,
        request.env['HTTP_X_HUB_SIGNATURE_256']
    )
end