# Summary
v3 Envoy configuration that demonstrates how to rewrite a host header or a path.

## Implementation
This configuration creates an Envoy container that listens on port 80 that will split traffic evenly between 2 Python Flask containers that are only accessible from Envoy.

## Usage
I've added a `Makefile` to simplify the execution of commands. `docker-compose` is used to manage the underlying containers.

### Launch Containers
For this configuration, I've configured `docker-compose` to launch the containers in the foreground so you can clearly view requests that are sent to Envoy, are forwarded to both Flask containers.

```
make run
```

### Stop Containers

```
make stop
```

### Force Rebuild of Image First

```
make rebuild
```

## Key Configuration
### Rewrite Header

* host_rewrite_literal: replace the host header with a string literal

__envoy/envoy_proxy.yaml__

```yaml
routes:
## Match rules are process in order!
- match:
    prefix: "/rewrite-header"
  route:
    host_rewrite_literal: "app.newhostheader"
    cluster: web
```

In this example, the host header will be replaced with `app.newhostheader` if the path prefix is `/rewrite-header`.

### Rewrite Path

* prefix_rewrite: replace the matched path with a string literal

__envoy/envoy_proxy.yaml__

```yaml
routes:
## Match rules are process in order!
- match:
    prefix: "/rewrite-prefix"
  route:
    prefix_rewrite: "/prefix-has-been-rewritten"
    cluster: web2
```

In this example, the path will be replaced with `/prefix-has-been-rewritten` if the path prefix is `/rewrite-prefix`.