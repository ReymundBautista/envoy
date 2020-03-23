# Envoy TLS
Front-end proxy Envoy configuration that accepts TLS connections and routes traffic based on SNI hostname.

## Implementation
This configuration creates an Envoy container that listens on port 443 that will direct traffic via HTTP to two Flask containers that are only accessible from Envoy. Since Envoy is terminating the TLS connection, this configuration requires a server private and public certificate. The certificates generated from this repo will create a cert with two domain names: `app.local` and `app.alternate`. Envoy is configured to direct `app.local` traffic to one container and `app.alternate` to the other container. I've added a route `/whoami` and a synthetic response in the Envoy configuration to make it obvious which SNI listener filter was triggered. 

## Usage
I've added a `Makefile` to simplify the execution of commands. `docker-compose` is used to manage the underlying containers.

### Generating Certs
If you haven't already, you'll need to generate the certificates needed for this configuration. Go to the root of the repo and run these commands:

```
make create-ca-certs
make create-server-certs
```

### Copy Certs
Once the certs have been generated for the repo, you'll need to copy them into this configuration. Be sure that you are back in the `sni-match` folder and run the following command:

```
make copy-certs
```

### Launch Containers
```
make run
```

### Stop Containers
```
make stop
```

### Verify SNI Filters
To validate that requests to `app.local` and `app.alternate` connect to different containers, run the following command. It uses `curl` to connect to Envoy.

```
make test-sni-match
```

```
HINT: Make sure you set app.local and app.alternate to 127.0.0.1 in your hosts file!

Running command: curl --cacert ../certs/CA.crt  https://app.local/whoami
Congrats! You have SNI matched the app.local filter!"

Running command: curl --cacert ../certs/CA.crt  https://app.alternate/whoami
Congrats! You have SNI matched the app.alternate filter!
```

## Key Configuration

__envoy/proxy-sni-match.yaml__

### TLS Inspector

Under `listeners:`, you'll need to add `listener_filters`.

Set the following attributes:

* `name`: This must be set to `envoy.listener.tls_inspector`

```yaml
listener_filters:
  - name: envoy.listener.tls_inspector
    typed_config: {}
```

### SNI Filter Chain Match
Under `filter_chains:`, add `filter_chain_match`.

Set the following attribute:

* `server_names`: The list of host names that you want the filter to match against. 

```yaml
filter_chains:
- filter_chain_match:
    server_names: ["app.local"]
```

### Synthetic Response
In this example, I added an arbitrary route `/whoami` where I wanted a synthetic response.

To add a synthetic response, add `direct_response` and set the following attributes:

* `status`: The desired HTTP status code
* `body`: Optionally add a response body. In my configuration, I used an inline response with the `inline_string` attribute. You could also use a file via the `filename` attribute.
```yaml
routes:
- match: { path: "/whoami" }
  direct_response:
    status: 200
    body: 
      inline_string: Congrats! You have SNI matched the app.local filter!"
```