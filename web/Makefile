VERSION = 0.1

## Use cache by default.  You can override the user via the commandline:  make target CACHE="--no-cache"
CACHE =

.PHONY: build-all build test tag_latest_all release ssh

help:
	@echo "General Commands"
	@echo "    help:  Show help"
	@echo ""
	@echo "Login to Docker Hub:"
	@echo "    login"
	@echo ""
	@echo "Build locally:"
	@echo "    build"
	@echo ""
	@echo "Run app Locally:"
	@echo "    run"
	@echo ""
	@echo "Stop (And remove) app:"
	@echo "    stop"
	@echo ""
	@echo "Rebuild (stop then run) app:"
	@echo "    rebuild"
	@echo ""

login:
	@docker login

build:
	@docker build --force-rm $(CACHE) -t thebernank/flask:$(VERSION) .

run:
	@docker run --rm  -p 8080:80 --name=flask1 thebernank/flask:latest

stop:
	@docker stop flask1

rebuild: stop run

tag-latest:
	docker tag thebernank/flask:$(VERSION) thebernank/flask:latest

release: tag-latest
	@if ! docker images thebernank/flask | awk '{ print $$2 }' | grep -q -F "$(VERSION)"; then echo "bankrate/runtime-node $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push thebernank/flask:$(VERSION)
	docker push thebernank/flask:latest
