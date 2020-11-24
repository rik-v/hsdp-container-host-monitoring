# container-host-monitoring

Terraform script to deploy jmx_exporter on container hosts (provisioned by Cartel):
1. jmx_exporter - https://github.com/prometheus/jmx_exporter         Gather info from JMX port and translate into Prometheus format

# Troubleshoot
1. The _container_ should expose **JMX** on port **5555**
1. The _container_ name should start as _container host name_
   
   Container name: **kafka**
   
   Container host: **kafka**-asdadadada-0.dev