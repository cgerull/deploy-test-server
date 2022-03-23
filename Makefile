.PHONY: helm-template help

default: help

helm-template: ## Generate Kubernetes manifests using Helm
	@sh -c "'$(CURDIR)/scripts/helm_template.sh' '$(envs)' '$(output_dir)'"

helmfile-template: ## Generate Kubernetes manifests using Helmfile
	@sh -c "'$(CURDIR)/scripts/helmfile_template.sh' '$(envs)' '$(output_dir)'"

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
