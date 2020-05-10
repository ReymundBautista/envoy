# Envoy Traffic Split
Proxy Envoy configuration that will split incoming traffic for a route between any number of upstream clusters.

## Overview
This configuration requries only `one` route. With the `weighted_clusters` configuration, you can split traffic based on a `weight` to any number of upstream clusters.

## Implementation
This configuration creates an Envoy container that listens on port 80 that will split traffic evenly between 3 Python Flask containers that are only accessible from Envoy.

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
To split traffic, add the `weighted_clusters` configuration under the target `route`. Then you can define a `clusters` configuration where you can define any number of cluster endpoints:

* `name`: The name of the upstream cluster.
* `weight`: Values must be `0 < x < 100`. The total weight should be exactly `100`.

__envoy/envoy_proxy.yaml__

```yaml
- match:
    prefix: "/"
  route:
    weighted_clusters:
      runtime_key_prefix: routing.traffic_split.split_service
      clusters:
        - name: web1
          weight: 33
        - name: web2
          weight: 33
        - name: web3
          weight: 34
```

This example shows an even split of traffic between `web1`, `web2`, `web3` upstream clusters.