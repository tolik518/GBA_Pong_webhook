.PHONY: build_image
build_image: 
	docker build -f docker/ruby/Dockerfile . -t webhook/ruby:dev

.PHONY: run
run:
	pwd=$$(pwd) docker-compose -f docker/docker-compose.yml up

.PHONY: stop
stop:
	docker-compose -f docker/docker-compose.yml down --remove-orphans