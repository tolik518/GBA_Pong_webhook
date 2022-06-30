This is the webhook-script I'm using to download the [artifacts](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts) from the [GBA Pong repository](https://github.com/tolik518/GBA_Pong) and to upload them [on my server](https://returnnull.de/github/GBA_Pong/) - resulting in an archive of nighly builds.

I've added a [Makefile](/Makefile) and a Dockerfile for [php](/docker/php/Dockerfile) and for [ruby](/docker/ruby/Dockerfile).  
So you can fire it up by just calling `make build_images` and `make run` afterwards in your terminal (asuming you got `make` and `docker` installed).

________

The ruby script `code/src/GBA_Pong_webhook.rb` is the script that receives the JSON payload and downloads it to the `FOLDER` while the `code/src/artifacts/index.php` just lists all files in that `FOLDER`.

________

The routine was created by losely following the official [webhooks guide](https://docs.github.com/en/developers/webhooks-and-events/webhooks/about-webhooks)

In the `code/src.env` you will have to set `FOLDER` to the folder the artifacts have been saved to.   
`TOKEN` is your [personal access token](https://github.com/settings/tokens) which you can get in your account settings.   
And `SECRET` is the secret that was set in the webhook configuration in the repository you are accessing.