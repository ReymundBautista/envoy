# Envoy TLS Upstream
Front-end proxy Envoy configuration that configures end-to-end TLS connection to the upstream cluster.

## Implementation
This configuration creates an Envoy container that listens on port 443 that will direct traffic via HTTPS to a Flask container that is only accessible from Envoy. Since Envoy is terminating the TLS connection, this configuration requires a server private and public certificate. The certificates generated from this repo will create a cert with two domain names: `app.local` and `app.alternate`. These same certificates will be added to the Flask container which is running `nginx`.

## Usage
I've added a `Makefile` to simplify the execution of commands. `docker-compose` is used to manage the underlying containers.

### Generating Certs
If you haven't already, you'll need to generate the certificates needed for this configuration. Go to the root of the repo and run these commands:

```
make create-ca-certs
make create-server-certs
```

### Copy Certs
Once the certs have been generated for the repo, you'll need to copy them into this configuration. Be sure that you are back in the `tls-upstream` folder and run the following command:

```
make copy-certs
```

### Build App Container
Since we need to override the default configuration for the app container to add TLS support, we need to build a new image first:
```
make build
```

### Launch Containers
```
make run
```

### Stop Containers
```
make stop
```

### Test Connection

```
make test
```

```
HINT: Make sure you set app.local to 127.0.0.1 in your hosts file!

Running command: curl --cacert ../certs/CA.crt  https://app.local
Hello Envoy world!
```

## Key Configuration
The main difference between this configuration and `tls-upstream` is adding a similar `transport-sockets` configuration to the upstream cluster.

__envoy/proxy-tls-upstream.yaml__

Things to note:
* `port_value`: Make sure to set this to `443` or whatever port that your upstream endpoint is listening on for TLS.
* `@type`: At the end, notice that the value is set to `UpstreamTlsContext` which is different from the listener config which has `DownstreamTlsContext`.

```yaml
clusters:
- name: app
  connect_timeout: 5s
  type: LOGICAL_DNS
  hosts: [{ socket_address: { address: app, port_value: 443 }}]
  transport_socket:
    name: envoy.transport_sockets.tls
    typed_config:
      "@type": type.googleapis.com/envoy.api.v2.auth.UpstreamTlsContext
```