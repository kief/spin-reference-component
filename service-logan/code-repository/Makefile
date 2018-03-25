.DEFAULT_GOAL := help
.PHONY: test

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FUNCTION=code-repository
DEPLOYMENT_ID=delivery
include $(MY_DIR)/../project-variables.mk

TERRAFORM_VARS=\
	-var "git_ssh_keyfile=$(HOME)/.ssh/git_ssh.pub" \
	-var "estate_id=$(ESTATE_ID)" \
	-var "component=$(COMPONENT)" \
	-var "role=$(ROLE)"

GIT_CLONE_URL="$(shell cd ./src && terraform output git_ssh_url)"
GIT_USERNAME="$(shell cd ./src && terraform output committer_ssh_id)"
SSH_CONFIGURED_FOR_CODECOMMIT=$(HOME)/.ssh/ssh_configured_for_codecommit_$(ESTATE_ID)_$(COMPONENT)_$(ROLE)


init: $(HOME)/.ssh/git_ssh.pub
	cd ./src && terraform init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=$(STATE_PATH)" \
		-backend-config="region=$(REGION)"

plan: init ## Preview changes without applying them
	cd ./src && terraform plan $(TERRAFORM_VARS)

apply: init ## Create or update infrastructure
	cd ./src && terraform apply -auto-approve $(TERRAFORM_VARS)

$(HOME)/.ssh/git_ssh.pub:
	ssh-keygen -t rsa -m PEM -b 4096 -C "infra_tester" -N '' -f $(HOME)/.ssh/git_ssh

git-client: $(SSH_CONFIGURED_FOR_CODECOMMIT)
	git config --global user.name "$(GIT_USERNAME)"
	git config --global push.default simple

$(SSH_CONFIGURED_FOR_CODECOMMIT): init
	@echo "" >> $(HOME)/.ssh/config
	echo "# Automatically added by the $(COMPONENT) project" >> $(HOME)/.ssh/config
	echo "Host git-codecommit.*.amazonaws.com" >> $(HOME)/.ssh/config
	@echo "  User $(GIT_USERNAME)" >> $(HOME)/.ssh/config
	@echo "  IdentityFile ~/.ssh/git_ssh" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	touch $(SSH_CONFIGURED_FOR_CODECOMMIT)

import: git-client ./build/.git/config ## Import source code into CodeCommit

copy-source:
	rm -rf ./build
	mkdir -p ./build
	( cd ../ && tar --exclude=code-repository -cf - . ) | ( cd ./build && tar xf - )

./build/.git/config: copy-source
	cd ./build && git init
	cd ./build && git add .
	cd ./build && git commit -m "Importing source"
	cd ./build && git remote add origin $(GIT_CLONE_URL)
	cd ./build && git push -u origin master

test: clean-test ## Test the infrastructure
	cd ./test && ./check_git_repo.sh $(GIT_CLONE_URL)

clean-test:
	rm -rf ./test/.output

out:
	cd ./src && terraform output

destroy: run-destroy distclean ## Destroy the infrastructure

run-destroy: init
	cd ./src && terraform destroy -force $(TERRAFORM_VARS)

clean: clean-test ## Clean local working files
	rm -rf ./src/.terraform ./src/*tfstate*

# TODO: This conflicts with the host & bastion ssh stuff
distclean: clean
	rm -rf ./build
	rm -f $(SSH_CONFIGURED_FOR_CODECOMMIT) ~/.ssh/config

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
