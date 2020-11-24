host=$1
docker rm -fv jmx_exporter
docker volume rm jmx_exporter
#docker rm -fv merge_exporter
#docker rm -fv node_exporter
docker volume create --driver local --name jmx_exporter --opt type=none --opt device=`pwd`/jmx --opt o=uid=root,gid=root --opt o=bind
docker run -d -p 10001:10002 \
--name jmx_exporter \
-v jmx_exporter:/opt/bitnami/jmx-exporter/example_configs \
bitnami/jmx-exporter:latest 10002 example_configs/config.yml

#docker run -d --name=cadvisor_exporter --device=/dev/kmsg -p 9102:8080 \
#-v /:/rootfs:ro -v /var/run:/var/run:ro -v /sys:/sys:ro \
#-v /var/lib/docker/:/var/lib/docker:ro -v /dev/disk/:/dev/disk:ro \
#gcr.io/cadvisor/cadvisor:v0.38.4
#docker stop zookeeper || echo "Zookeeper doesn't exist"
#docker run -d --name node_exporter -p 9101:9100 bitnami/node-exporter
#docker run -d --name merge_exporter \
#-e MERGER_PORT=8888 \
#-e MERGER_URLS="http://$host:9101/metrics http://$host:9102/metrics http://$host:9103" \
#-p 10001:8888 quay.io/rebuy/exporter-merger
#docker start zookeeper || echo "Zookeeper doesn't exist"
