FROM envoyproxy/envoy-alpine:latest

RUN apk --no-cache add curl
COPY proxy-tls.yaml /etc/proxy-tls.yaml
CMD /usr/local/bin/envoy -c /etc/proxy-tls.yaml --service-cluster proxy-tls