This is the webhook-script I'm using to download the [artifacts](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts) from the [GBA Pong repository](https://github.com/tolik518/GBA_Pong) and to upload them [on my server](https://returnnull.de/github/GBA_Pong/) - resulting in an archive of nighly builds.

I've added a [Makefile](/Makefile) and a Dockerfile for [ruby](/docker/ruby/Dockerfile).  
So you can fire it up by just calling `make build_image` and `make run` afterwards in your terminal (asuming you got `make` and `docker` installed).

________

The ruby script `code/src/index.rb` is the entrypoint. It has the routes for the [artifact-serving](https://returnnull.de/github/GBA_Pong/) - it just displays the content of `FOLDER` and the route for the webhook which receives the JSON payload and downloads it to the `FOLDER`.

________

The routine was created by losely following the official [webhooks guide](https://docs.github.com/en/developers/webhooks-and-events/webhooks/about-webhooks)

In the `.env` you will have to set `FOLDER` to the folder the artifacts are saved to.   
`TOKEN` is your [personal access token](https://github.com/settings/tokens) which you can get in your account settings.   
And `SECRET` is the secret that was set in the webhook configuration in the repository you are accessing.