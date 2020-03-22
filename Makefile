.PHONY: build-all build test tag_latest_all release ssh

help:
	@echo "General Commands"
	@echo "    help:  Show help"

create-ca-certs:
	@bash scripts/generate-cacerts.sh

create-server-certs:
	@bash scripts/generate-certs.sh

verify-server-certs:
	@openssl s_server -accept 12345 -key certs/app.key -cert certs/app.crt

# Validate certificate matches the key file
view-server-certs-modulus:
	@openssl rsa -noout -modulus -in certs/app.key
	@echo ""
	@openssl req -noout -modulus -in certs/cert.csr
	@echo ""
	@openssl x509 -noout -modulus -in certs/app.crt