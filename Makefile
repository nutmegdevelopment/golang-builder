DOCKER ?= docker
DOCKER_REPO_NAME ?= localhost
DOCKER_TESTER_IMAGE_NAME ?= golang-tester
DOCKER_BUILDER_IMAGE_NAME ?= golang-builder
GOLANG_VERSION ?= 1.9.3
DOCKER_IMAGE_TAG ?= $(GOLANG_VERSION)-$(subst /,-,$(shell git rev-parse --abbrev-ref HEAD))
GOSS ?= dgoss

build:
	@echo ">> building golang-builder"
	$(DOCKER) build -t $(DOCKER_REPO_NAME)/$(DOCKER_BUILDER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) -f builder/Dockerfile builder/
	$(DOCKER) build -t $(DOCKER_REPO_NAME)/$(DOCKER_BUILDER_IMAGE_NAME):latest -f builder/Dockerfile builder/
	@echo ">> building golang-tester"
	$(DOCKER) build -t $(DOCKER_REPO_NAME)/$(DOCKER_TESTER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) -f tester/Dockerfile tester/
	$(DOCKER) build -t $(DOCKER_REPO_NAME)/$(DOCKER_TESTER_IMAGE_NAME):latest -f tester/Dockerfile tester/

push:
	@echo ">> pushing golang-builder image"
	$(DOCKER) push $(DOCKER_REPO_NAME)/$(DOCKER_BUILDER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)
	$(DOCKER) push $(DOCKER_REPO_NAME)/$(DOCKER_BUILDER_IMAGE_NAME):latest
	@echo ">> pushing golang-tester image"
	$(DOCKER) push $(DOCKER_REPO_NAME)/$(DOCKER_TESTER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)
	$(DOCKER) push $(DOCKER_REPO_NAME)/$(DOCKER_TESTER_IMAGE_NAME):latest

test:
	@echo ">> testing golang-builder image"
	$(GOSS) run -i \
	--entrypoint="/bin/bash" \
	$(DOCKER_REPO_NAME)/$(DOCKER_BUILDER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

	@echo ">> testing golang-tester image"
	$(GOSS) run -i \
	--entrypoint="/bin/bash" \
	$(DOCKER_REPO_NAME)/$(DOCKER_TESTER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)