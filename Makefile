.DEFAULT_GOAL := help

setup-delivery:  ## Setup each service project's source repo and pipelines
	cd service-ororo && make setup-delivery
	cd service-logan && make setup-delivery

plan-delivery: ## See what's involved in setting up the delivery infrastructure
	cd service-ororo && make plan-delivery
	cd service-logan && make plan-delivery

destroy-delivery: ## Destroy the source repos and pipelines, but not infrastructure
	cd service-ororo && make destroy-delivery
	cd service-logan && make destroy-delivery

plan: ## Plan all the service infrastructure for a deployment collection
	cd service-ororo && make plan
	cd service-logan && make plan

up: ## Bring up all the service infrastructure for a deployment collection
	cd service-ororo && make up
	cd service-logan && make up

destroy: ## Destroy all the service infrastructure for a deployment collection
	cd service-ororo && make destroy
	cd service-logan && make destroy

clean: ## Clean local files
	cd service-ororo && make clean
	cd service-logan && make clean

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
