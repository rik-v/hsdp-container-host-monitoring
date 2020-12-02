mkdir -p jmx
container_names=`docker ps --format {{.Names}}`
arr=($container_names)
echo "All Container Names : ${arr[*]}"
echo "Container First Name: ${arr[0]}"
export container_name=${arr[0]}
envsubst < config.yml.tmpl > config.yml
mv config.yml ./jmx
docker rm -fv jmx_exporter
docker volume rm jmx_config_volume
docker volume create --driver local --name jmx_config_volume --opt type=none --opt device=`pwd`/jmx --opt o=uid=root,gid=root --opt o=bind
docker run -d -p 10001:5556 \
--name jmx_exporter --link ${container_name} \
-v jmx_config_volume:/opt/bitnami/jmx-exporter/example_configs \
bitnami/jmx-exporter:latest 5556 example_configs/config.yml