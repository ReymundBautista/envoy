.PHONY: build-all build test tag_latest_all release ssh

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
	@echo "Run Envoy:"
	@echo "    run"
	@echo ""
	@echo "Stop Envoy:"
	@echo "    stop"
	@echo ""
	@echo "Rebuild (stop + start) Envoy:"
	@echo "    rebuild"
	@echo ""
	@echo "Verify TLS connection:"
	@echo "    test-tls"
	@echo ""

copy-certs:
	@mkdir -p certs
	@cp ../certs/app.* certs/

verify-config:
	@docker run --rm -v "`pwd`/envoy/proxy-tls.yaml":/etc/proxy-tls.yaml \
	                 -v "`pwd`/certs/app.key":/etc/app.key \
					 -v "`pwd`/certs/app.crt":/etc/app.crt \
					 envoyproxy/envoy-alpine:latest envoy -c /etc/proxy-tls.yaml --mode validate 

run:
	@docker-compose -p envoy-tls up -d --force-recreate

stop:
	@docker-compose -p envoy-tls down

rebuild: stop run

test-tls:
	@echo "HINT: Make sure you set app.local to 127.0.0.1 in your hosts file!"
	@echo ""
	@echo "Running command: curl -v --cacert ../certs/CA.crt  https://app.local/"
	@echo ""
	@curl -v --cacert ../certs/CA.crt  https://app.local/
