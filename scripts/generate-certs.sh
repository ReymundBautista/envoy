#!/bin/bash
openssl genrsa -out certs/app.key 4096
openssl req -new -key certs/app.key -out certs/cert.csr \
    -subj '/C=US/ST=MI/O=mr8ball/CN=envoy-testing' -config scripts/server-openssl.cnf
openssl x509 -req -in certs/cert.csr -CA certs/CA.crt \
    -CAkey certs/CA.key -CAcreateserial \
    -out certs/app.crt -days 10000 -extensions v3_req \
    -extfile scripts/server-openssl.cnf -set_serial 1