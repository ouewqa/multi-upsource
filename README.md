# step1. run Data Volume Container

docker run --name upsource-data-8080 \
	-v /opt/Upsource/8080/conf:/opt/Upsource/conf \
	-v /opt/Upsource/8080/data:/opt/Upsource/data \
	-v /opt/Upsource/8080/logs:/opt/Upsource/logs \
	-v /opt/Upsource/8080/backups:/opt/Upsource/backups \
	busybox /bin/true

docker run --name upsource-data-8081 \
	-v /opt/Upsource/8081/conf:/opt/Upsource/conf \
	-v /opt/Upsource/8081/data:/opt/Upsource/data \
	-v /opt/Upsource/8081/logs:/opt/Upsource/logs \
	-v /opt/Upsource/8081/backups:/opt/Upsource/backups \
	busybox /bin/true



# step2. config

docker run \
    --rm \
    --volumes-from upsource-data-8080 \
    -u=root \
    --name upsource-8080 \
    yuyunjian/upsource bin/upsource.sh configure \
    --listen-port 8080 \
    --base-url http://localhost:8080

docker run \
    --rm \
    --volumes-from upsource-data-8081 \
    -u=root \
    --name upsource-8081 \
    yuyunjian/upsource bin/upsource.sh configure \
    --listen-port 8081 \
    --base-url http://localhost:8081



# step3. install
docker run \
	-d \
	-u=root \
	--volumes-from upsource-data-8080 \
	--expose=8080 \
	-p 8080:8080 \
	--name upsource-8080 \
	yuyunjian/upsource \
	bin/upsource.sh run

docker run \
	-d \
	-u=root \
	--volumes-from upsource-data-8081 \
	--expose=8081 \
	-p 8081:8081 \
	--name upsource-8081 \
	yuyunjian/upsource \
	bin/upsource.sh run
