# container-host-monitoring

Terraform script to deploy few exporters on container hosts (provisioned by Cartel):
1. cadvisor_exporter - https://github.com/google/cadvisor/         Docker exporter for Prometheus
1. node_exporter     - https://github.com/prometheus/node_exporter Prometheus exporter for hardware and OS metrics exposed by UNIX kernels, with pluggable metric collectors.
1. exporter-merger   - https://github.com/rebuy-de/exporter-merger Merges Prometheus metrics from multiple sources.


# Troubleshoot

1. Currently there is problem on AWS instance _t3.medium_ with deployed Zookeeper.

```docker: Error response from daemon: OCI runtime create failed: container_linux.go:349: starting container process caused "process_linux.go:449: container init caused \"process_linux.go:432: running prestart hook 0 caused \\\"error running hook: signal: segmentation fault, stdout: , stderr: \\\"\"": unknown.) ```

**Workaround 1** : 
1. stop Zookeeper docker 
1. deploy exporters
1. start Zookeeper docker

**Workaround 2** :
1. Use _t3.large_

 