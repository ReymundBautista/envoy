FROM envoyproxy/envoy-alpine:latest

RUN apk --no-cache add curl
COPY proxy-sni-match.yaml /etc/proxy-sni-match.yaml
CMD /usr/local/bin/envoy -c /etc/proxy-sni-match.yaml --service-cluster proxy-sni-match