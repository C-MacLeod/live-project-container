default: build

build:
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder

run:
	@docker run -dit -p 1313:1313 -v $(PWD)/orgdocs:/src --name hugo lp/hugo-builder

hadolint:
	@docker run --rm -i hadolint/hadolint < Dockerfile

clean:
	@echo stopping hugo container
	@-docker stop hugo
	@echo removing hugo container
	@-docker rm hugo
	@echo removing lp/hugo-builder image
	@-docker rmi lp/hugo-builder

all:
	make clean
	make hadolint
	make build


check_health:
	@echo "Checking the health of the Hugo Server..."
	@docker inspect --format='{{json .State.Health}}' hugo

.PHONY: all clean hadolint check_health run build


