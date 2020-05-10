.PHONY: build-all build test tag_latest_all release ssh

CONFIG_NAME = "envoy-proxy.yaml"
COMPOSE_NAME = "envoy-traffic-split"

help:
	@echo "General Commands"
	@echo "    help:  Show help"
	@echo ""
	@echo "Verify Envoy config locally:"
	@echo "    verify-config"
	@echo ""
	@echo "Run Envoy:"
	@echo "    run"
	@echo ""
	@echo "Stop Envoy:"
	@echo "    stop"
	@echo ""
	@echo "Build Envoy:"
	@echo "    build"
	@echo ""
	@echo "Rebuild (stop, build, run) Envoy:"
	@echo "    rebuild"
	@echo ""
	@echo "Verify if Envoy is listening on port 80:"
	@echo "    check-listener"
	@echo ""


verify-config:
	@docker run --rm -v "`pwd`/envoy/$(CONFIG_NAME)":/etc/$(CONFIG_NAME) envoyproxy/envoy-alpine:latest envoy -c /etc/$(CONFIG_NAME) --mode validate

run:
	@docker-compose -p $(COMPOSE_NAME) up --force-recreate

stop:
	@docker-compose -p $(COMPOSE_NAME) down

build:
	@docker-compose -p $(COMPOSE_NAME) build --force-rm --no-cache

rebuild: stop build run

check-listener:
	@netstat -an -ptcp | grep LISTEN | grep "*.80"
