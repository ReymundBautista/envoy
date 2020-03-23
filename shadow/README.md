# Envoy Shadow Mirroring
Front-end proxy Envoy configuration that shadows incoming traffic.

## Overview
`Shadow Mirroring` takes incoming traffic and creates a copy of the traffic, allowing you to send it to a different upstream cluster. This could be used before a migration, using production volume of traffic to catch unexpected errors and run regression tests.

## Implementation
This configuration creates an Envoy container that listens on port 80 that will direct traffic to 2 Python Flask containers that are only accessible from Envoy.

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

## Caveats
There are a couple of significant caveats that I discovered with this configuration.

### -shadow suffix
Envoy appends `-shadow` to the host header for every request. To be clear, it's adding it to the very end of the host header rather than the host name. For example: `www.example.org-shadow`

This could be problematic if you were planning to direct the traffic via TLS to the upstream cluster since the certificate won't match.

### tcp_proxy filter not supported
If you are planning to use a TLS passthru configuration, you need to implement the `tcp_proxy` filter. Unfortunately, the shadowing capability isn't supported for `tcp_proxy`, it's only supported with the `http_connection_manager` filter.

## Key Configuration
To add a shadow, add the `request_mirror_policies` attribute for the target `route`. You'll need to set a couple of attributes:

* `cluster`: The upstream cluster to send the shadow traffic to
* `runtime_fraction`: The % of traffic to send to the shadow upstream cluster

__envoy/proxy_mirror.yaml__

```yaml
route:
    cluster: web
    request_mirror_policies:
        cluster: shadow
        runtime_fraction: { default_value: { numerator: 100 } }
```