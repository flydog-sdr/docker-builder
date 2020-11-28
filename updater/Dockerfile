# pi@raspberrypi:~ $ docker network create -d bridge flydog-sdr
# pi@raspberrypi:~ $ git clone https://github.com/flydog-sdr/docker-builder docker-builder
# pi@raspberrypi:~ $ cd docker-builder/updater
# pi@raspberrypi:~/docker-builder/updater $ docker build -t updater:latest .
# pi@raspberrypi:~/docker-builder/updater $ docker run -d \
#   --name updater \
#   --network flydog-sdr \
#   --publish 3708:3708 \
#   --restart always \
#   --volume /usr/bin/docker:/usr/bin/docker \
#   --volume /var/run/docker.sock:/var/run/docker.sock \
#   --volume kiwi.config:/etc/kiwi.config \
#   updater:latest

FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

ADD entrypoint.sh /opt/entrypoint.sh
ADD updater.sh /usr/bin/updater.sh

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y busybox cron curl jq \
    && chmod +x /opt/entrypoint.sh /usr/bin/updater.sh \
    && echo "0 4 * * * /usr/bin/scripts/updater.sh" | crontab -

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
