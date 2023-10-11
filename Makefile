# Test Minerva charts locally
#

# GitLab repository aand group variables
REGISTRY := docker.io
REGISTRY_PATH := cgerull
CI_PROJECT_NAME := testserver
# CI_PROJECT_NAME := ${PROJECT_NAME}
CI_PIPELINE_ID := ''

# Variables from .gitlab-ci.yml
APP_VERSION := 0.9.14
# When we are using pipeline ID switch the next 2 lines.
# VERSION := $(APP_VERSION)-$(CI_PIPELINE_ID)
VERSION := $(APP_VERSION)
PROJECT_NAME := $(CI_PROJECT_NAME)
CHART_NAME := $(PROJECT_NAME)
APP_NAME := testserver
# CI_REGISTRY_IMAGE := $(REGISTRY)/$(PROJECT_NAME)
IMAGE_REGISTRY_PATH := $(REGISTRY)/$(REGISTRY_PATH)
IMAGE_NAME := $(IMAGE_REGISTRY_PATH)/$(PROJECT_NAME)

# Make variables
CHARTS_PATH := charts
KUBE_DIR := kubernetes
ENV := dev-local

# default target, when make executed without arguments
help:           	## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Image ***************************************************************
$(PROJECT_NAME).tar:
	@time docker build --no-cache --build-arg <Appname>VERSION=$(APP_VERSION) --tag "$(IMAGE_NAME):$(VERSION)" --tag "$(IMAGE_NAME):latest" build;
	@time docker save -o $(PROJECT_NAME).tar $(IMAGE_NAME):$(VERSION) ;

image:$(PROJECT_NAME).tar	## Build docker image
	@echo "Used $(PROJECT_NAME).tar"

# Only on systems with prismacloud vulnerability scanner.
image-scan-prismacloud:image	## Scan image with prismascan
	@time prismacloud-scan.sh "$(IMAGE_NAME):$(VERSION)" | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tee -a public/prismacloudscan.txt
	# define report
	# echo "<h1>Prisma Cloud Scan</h1>" >> public/index.html
	# - echo "<b>" >> public/index.html
	# - echo     "<p>" >> public/index.html
	# - echo         "<iframe src='prismacloudscan.txt' width="1024" height="800" frameborder='0'></iframe>" >> public/index.html
	# - echo     "</p>" >> public/index.html
	# - echo "</b>" >> public/index.html
	# endef
	# export report

  # Only on systems with trivyvulnerability scanner.
image-scan-trivy:image 	## Scan image with aquasec trivy
	@echo "Start trivy scan ..."
	time docker run aquasec/trivy image --severity HIGH,CRITICAL --quiet --output $(PROJECT_NAME).txt $(IMAGE_NAME):$(VERSION)

scan-report:image-scan-prismacloud	## Create HTML page with image scan results
	@if [ ! -d public ]; then \
	mkdir -p public; \
	fi;
	echo "<h1>Prisma Cloud Scan</h1>" >> public/index.html;
	echo "<b>" >> public/index.html;
	echo     "<p>" >> public/index.html;
	echo         "<iframe src="$(PROJECT_NAME).txt" width="1024" height="800" frameborder='0'></iframe>" >> public/index.html;
	echo     "</p>" >> public/index.html;
	echo "</b>" >> public/index.html;

image-push:$(PROJECT_NAME).tar	## Push docker image to registry
	@time docker push $(IMAGE_NAME):$(VERSION);
	@time docker push $(IMAGE_NAME):latest;

# Helm chart **********************************************************
chart:			## Configure and build helm chart
	@if [ ! -f $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml.org ]; then \
	cp $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml.org; \
	fi;
	@echo "Saved original Chart.yaml"
	# echo "Set chart.yaml information."
	@sed -ri "s/^(name:).*$$/\1 ${APP_NAME}/g" $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml;
	@sed -ri 's/^(appVersion:).*$$/\1 ${VERSION}/g' $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml;
	# @sed -ri 's!^(version:).*$$!\1 '${VERSION}'!g' $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml
	@cat $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml

lint:chart		## Helm lint chart
	helm lint ./"$(CHARTS_PATH)/$(CHART_NAME)";

manifest:lint		## Make kubernetes manifests (helm template)
	@if [ ! -d $(KUBE_DIR)/$(ENV) ]; then \
	mkdir -p $(KUBE_DIR)/$(ENV); \
	fi;
	helm template $(APP_NAME) --values deploy/$(ENV)/$(CHART_NAME).yaml "$(CHARTS_PATH)/$(CHART_NAME)" > $(KUBE_DIR)/$(ENV)/$(CHART_NAME).yaml

secret:
	@if [ $(ENV)~='local' ]; then \
	  kubectl create secret generic $(CHART_NAME) --from-literal=my_secret=DevHelmChartSecret; \
	fi;

package-chart:lint	## Create helm package
	@if [ ! -d packages ]; then \
	mkdir -p packages; \
	fi;
	## Build a helm package
	helm package -d packages $(CHARTS_PATH)/$(CHART_NAME)

push-chart:package-chart push-image
	helm push $(CHARTMUSEUM)
	# helm --debug nexus-push nexus-helm3 packages/*.tgz

docs:			## Generate README.md
	helm-docs $(CHARTS_PATH)/$(CHART_NAME)

# Testing *************************************************************
chart-dry-run:manifest	## Perform a kubernetes dry-run; Shell needs to have access to clustermake clea
	kubectl apply -f $(KUBE_DIR)/$(CHART_NAME).yaml --dry-run=client

chart-get-current:	## Retrieve current manifests from cluster. Require cluster connection.
	@if [ ! -d $(KUBE_DIR)/current ]; then \
	mkdir -p $(KUBE_DIR)/current; \
	fi;
	@if [ -f $(KUBE_DIR)/current/$(CHART_NAME).yaml ]; then \
	rm $(KUBE_DIR)/current/$(CHART_NAME).yaml; \
	fi;
	@echo "---"  >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@kubectl get pvc $(APP_NAME)-data -o yaml | kubectl neat >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@echo "---"  >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@kubectl get pvc $(APP_NAME)-extensions -o yaml | kubectl neat >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@echo "---"  >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@kubectl get svc $(APP_NAME) -o yaml | kubectl neat >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@echo "---"  >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@kubectl get deploy $(APP_NAME) -o yaml | kubectl neat >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@echo "---"  >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@kubectl get ing $(APP_NAME) -o yaml | kubectl neat >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@echo "---"  >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@kubectl get database $(APP_NAME) -o yaml | kubectl neat >> $(KUBE_DIR)/current/$(CHART_NAME).yaml
	@echo "Fetched kubernetes manifests from cluster."

# Round up ************************************************************
clean:			## Clean all artefacts
	@if [ -d pluto ]; then rm -rf pluto; fi
	@echo "Cleaned pluto artefacts."
	@rm -f *.tar
	@rm -f *.tgz
	@echo "Cleaned archives."
	@rm -rf packages
	@echo "Cleaned helm packages."
	@rm -f $(CHARTS_PATH)/$(CHART_NAME)/README.md
	@echo "Cleaned chart README files."
	@if [ -d $(KUBE_DIR) ]; then rm -rf $(KUBE_DIR); fi
	@echo "Cleaned kubernetes manifest."
	@if [ -f $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml.org ]; then \
	cp $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml.org $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml; \
	rm $(CHARTS_PATH)/$(CHART_NAME)/Chart.yaml.org; \
	fi;
	@echo "Reset Chart.yaml"


all: push-chart gen-docs   ## Run all commands

.PHONY: push-image chart lint package-chart push-chart docs clean dry-run
