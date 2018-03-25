.DEFAULT_GOAL := help

setup:  ## Setup each service project's source repo and pipelines
	cd service-ororo && make setup
	cd service-logan && make setup

plan-setup: ## See what needs doing for the service projects' setup
	cd service-ororo && make plan-setup
	cd service-logan && make plan-setup

plan: ## Plan all the services
	cd service-ororo && make plan
	cd service-logan && make plan

up: ## Bring up all the services
	cd service-ororo && make up
	cd service-logan && make up

destroy: ## Destroy all the services (only the relevant deployment collection)
	cd service-ororo && make destroy
	cd service-logan && make destroy

clean: ## Clean the service projects. Doesn't tear down infrastructure.
	cd service-ororo && make clean
	cd service-logan && make clean

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
