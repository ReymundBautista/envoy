FROM envoyproxy/envoy-alpine:v1.14.1
RUN apk --no-cache add curl
COPY envoy-proxy.yaml /etc/envoy-proxy.yaml
## You can't use ARG in CMD ;_;
## https://github.com/moby/moby/issues/34772
CMD ["/usr/local/bin/envoy", "-c", "/etc/envoy-proxy.yaml", "--service-cluster", "envoy-proxy"]
