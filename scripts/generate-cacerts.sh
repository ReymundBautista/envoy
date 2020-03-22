#!/bin/bash
openssl genrsa -out certs/CA.key 4096
openssl req -x509 -new -nodes -key certs/CA.key -sha256 -days 10000 -out certs/CA.crt