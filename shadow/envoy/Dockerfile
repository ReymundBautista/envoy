FROM envoyproxy/envoy-alpine:latest

RUN apk --no-cache add curl
COPY proxy-mirror.yaml /etc/proxy-mirror.yaml
CMD /usr/local/bin/envoy -c /etc/proxy-mirror.yaml --service-cluster proxy-mirror
