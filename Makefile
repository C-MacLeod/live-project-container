default: build

build:
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder

.PHONY: build

run:
	@docker run -dit -p 1313:1313 -v $(PWD)/orgdocs:/src --name hugo lp/hugo-builder
.PHONY: run

hadolint:
	@docker run --rm -i hadolint/hadolint < Dockerfile

.PHONY: hadolint

clean:
	@echo stopping hugo container
	@-docker stop hugo
	@echo removing hugo container
	@-docker rm hugo
	@echo removing lp/hugo-builder image
	@-docker rmi lp/hugo-builder

.PHONY: clean

all:
	make clean
	make hadolint
	make build

.PHONY: all

