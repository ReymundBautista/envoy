FROM envoyproxy/envoy-alpine:latest

RUN apk --no-cache add curl
COPY proxy-tls-upstream.yaml /etc/proxy-tls-upstream.yaml
CMD /usr/local/bin/envoy -c /etc/proxy-tls-upstream.yaml --service-cluster proxy-tls-upstream