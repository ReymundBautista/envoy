# Envoy Traffic Shift
Proxy Envoy configuration that shifts incoming traffic for a route between two upstream clusters.

## Overview
`Traffic shifting` takes incoming traffic and allows you to shift traffic between two upstream clusters. This configuration requries two routes, but with the first route is where you configure the split %. This configuration could be used to migrate traffic from an old to newer platform.

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
To shift traffic, add the `runtime_fraction` attribute under the target `match`. This will determine the % of traffic to be sent to the first matched route. Remaining traffic will be sent to the following route.

* `numerator`: Values must be `0 < x < 100`
* `denominator`: Can only be HUNDRED, TEN_THOUSAND, or MILLION

__envoy/envoy_proxy.yaml__

```yaml
- match:
    prefix: "/"
    runtime_fraction:
    default_value:
      numerator: 50
      denominator: HUNDRED # Can only be HUNDRED, TEN_THOUSAND, or MILLION
    runtime_key: routing.traffic_shift.split_service
  route:
    cluster: web
- match:
    prefix: "/"
  route:
    cluster: web2
```

This example shows a 50/50 split of traffic between `web1` and `web2` upstream clusters.