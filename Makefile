-include .env

IMAGE = "nginx:1.17"
CONTAINER = $(if $(CUSTOM_CONTAINER),$(CUSTOM_CONTAINER),nginx-basic)
HOST_PORT = $(if $(CUSTOM_HOST_PORT),$(CUSTOM_HOST_PORT),80)


all:
	@echo "Hello $(LOGNAME), nothing to do by default"
	@echo "Try 'make help'"

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: remove ## Build the container
	@docker run -dit \
		--name $(CONTAINER) \
		-v "$(PWD)/build":/assets/build \
		-v "$(PWD)/nginx.conf":/etc/nginx/nginx.conf \
		-p $(HOST_PORT):80 \
		$(IMAGE)

cmd: start ## Access bash
	@docker exec -it /bin/bash

up: ## Start container
	@docker start $(CONTAINER)

down: ## Stop container
	@docker stop $(CONTAINER) || true

restart: ## Restart container
	@docker restart $(CONTAINER) || true

remove: down  ## Remove the container
	@docker rm $(CONTAINER) || true


.DEFAULT_GOAL := help
