FROM envoyproxy/envoy-alpine:latest

RUN apk --no-cache add curl
COPY proxy-tls-passthru.yaml /etc/proxy-tls-passthru.yaml
CMD /usr/local/bin/envoy -c /etc/proxy-tls-passthru.yaml --service-cluster proxy-tls-passthru