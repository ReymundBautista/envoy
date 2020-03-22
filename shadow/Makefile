.PHONY: build-all build test tag_latest_all release ssh

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


verify-config:
	@docker run --rm -v "`pwd`/envoy/proxy-mirror.yaml":/etc/proxy-mirror.yaml envoyproxy/envoy-alpine:latest envoy -c /etc/proxy-mirror.yaml --mode validate 

run:
	@docker-compose -p envoy-shadow up --force-recreate

stop:
	@docker-compose -p envoy-shadow down

rebuild: stop run
