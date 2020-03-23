# Envoy TLS
Front-end proxy Envoy configuration that accepts and terminates TLS connections.

## Implementation
This configuration creates an Envoy container that listens on port 443 that will direct traffic via HTTP to a Flask container that is only accessible from Envoy. Since Envoy is terminating the TLS connection, this configuration requires a server private and public certificate. The certificates generated from this repo will create a cert with two domain names: `app.local` and `app.alternate`.

## Usage
I've added a `Makefile` to simplify the execution of commands. `docker-compose` is used to manage the underlying containers.

### Generating Certs
If you haven't already, you'll need to generate the certificates needed for this configuration. Go to the root of the repo and run these commands:

```bash
make create-ca-certs
make create-server-certs
```

### Copy Certs
Once the certs have been generated for the repo, you'll need to copy them into this configuration. Be sure that you are back in the `tls-terminate` folder and run the following command:

```bash
make copy-certs
```

### Launch Containers
```bash
make run
```

### Stop Containers
```bash
make stop
```

### Verify TLS Connection
To validate that you can connect to Envoy via TLS, run the following command. It will use `curl` to connect.

```bash
make test-tls
```

## Key Configuration
To enable TLS, you will need to add the `transport_socket` attribute under `filter_chains`. You'll need to set the following attributes:

* `name`: Set this to `envoy.transport_sockets.tls`
* `typed_config`: Set `@type` to `type.googleapis.com/envoy.api.v2.auth.DownstreamTlsContext` to ensure you are configuring the downstream (requests sent to Envoy) configuration.
* `certificate_chain`: This is the path to the public server certificate
* `private_key`: This is the certificate private key
* `alpn_protocols`: You can optionally set `alpn_protocols` to explicitly set the ALPN protocols (e.g. HTTP 1.1, HTTP/2) that the TLS listener should expose.

__envoy/proxy_tls.yaml__

```yaml
filter_chains:
- transport_socket:
    name: envoy.transport_sockets.tls
    typed_config:
      "@type": type.googleapis.com/envoy.api.v2.auth.DownstreamTlsContext
      common_tls_context:
        tls_certificates:
        - certificate_chain: { filename: "/etc/app.crt" }
          private_key: { filename: "/etc/app.key" }
        alpn_protocols: [ "h2,http/1.1" ]
```