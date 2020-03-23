.PHONY: build-all build test tag_latest_all release ssh

APP="tls-upstream"

help:
	@echo "General Commands"
	@echo "    help:  Show help"
	@echo ""
	@echo "Copy certs:"
	@echo "    copy-certs"
	@echo ""
	@echo "Verify Envoy config locally:"
	@echo "    verify-config"
	@echo ""
	@echo "Build Flask App:"
	@echo      build"
	@echo ""
	@echo "Run Envoy:"
	@echo "    run"
	@echo ""
	@echo "Stop Envoy:"
	@echo "    stop"
	@echo ""
	@echo "Rebuild (stop + start) Envoy:"
	@echo "    rebuild"
	@echo ""
	@echo "Validate that connection to Flask app succeeds:"
	@echo "    test"
	@echo ""

copy-certs:
	@mkdir -p certs
	@cp ../certs/app.* certs/

verify-config:
	@docker run --rm -v "`pwd`/envoy/proxy-$(APP).yaml":/etc/proxy-$(APP).yaml \
	                 -v "`pwd`/certs/app.key":/etc/app.key \
					 -v "`pwd`/certs/app.crt":/etc/app.crt \
					 envoyproxy/envoy-alpine:latest envoy -c /etc/proxy-$(APP).yaml --mode validate 

build:
	@docker-compose -p envoy-$(APP) build

run:
	@docker-compose -p envoy-$(APP) up -d --force-recreate

stop:
	@docker-compose -p envoy-$(APP) down

rebuild: stop run

test:
	@echo "HINT: Make sure you set app.local to 127.0.0.1 in your hosts file!"
	@echo ""
	@echo "Running command: curl --cacert ../certs/CA.crt  https://app.local"
	@curl --cacert ../certs/CA.crt  https://app.local
