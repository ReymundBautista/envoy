# Envoy TLS Passthru
Front-end proxy Envoy configuration that forwards TLS connection directly to the upstream cluster with SNI filtering.

## Implementation
This configuration creates an Envoy container that listens on port 443 that will forward traffic via HTTPS to a Flask container that is only accessible from Envoy. Since the Flask app needs to respond to a TLS request, certificates are needed. The certificates generated from this repo will create a cert with two domain names: `app.local` and `app.alternate`.

## Usage
I've added a `Makefile` to simplify the execution of commands. `docker-compose` is used to manage the underlying containers.

### Generating Certs
If you haven't already, you'll need to generate the certificates needed for this configuration. Go to the root of the repo and run these commands:

```
make create-ca-certs
make create-server-certs
```

### Copy Certs
Once the certs have been generated for the repo, you'll need to copy them into this configuration. Be sure that you are back in the `tls-passthru` folder and run the following command:

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
make test-envoy
```

```
HINT: Make sure you set app.local to 127.0.0.1 in your hosts file!

Running command: curl --cacert ../certs/CA.crt  https://app.local
Hello Envoy world!
```

## Key Configuration
This configuration utilizes the `tcp_proxy` filter. At it's most minimal configuration, it's very basic. Since we are using SNI filtering for matching, once matched, all this `tcp_proxy` filter does is forward the traffic to the target upstream cluster.

__envoy/proxy-tls-passthru.yaml__

Things to note:
* `cluster`: Set this to the desired upstream cluster that you want to forward traffic to.

```yaml
filters:
- name: envoy.tcp_proxy
  config:
    stat_prefix: ingress_tcp
    cluster: app
    access_log:
      - name: envoy.file_access_log
        config:
          path: "/dev/stdout"
```