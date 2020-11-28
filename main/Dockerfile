# pi@raspberrypi:~ $ docker network create -d bridge flydog-sdr
# pi@raspberrypi:~ $ git clone https://github.com/flydog-sdr/docker-builder docker-builder
# pi@raspberrypi:~ $ cd docker-builder/main
# pi@raspberrypi:~/docker-builder/main $ docker build -t flydog-sdr:latest .
# pi@raspberrypi:~/docker-builder/main $ docker run -d \
#   --hostname flydog-sdr \
#   --name flydog-sdr \
#   --network flydog-sdr \
#   --privileged \
#   --publish 8073:8073 \
#   --restart always \
#   --volume kiwi.config:/root/kiwi.config \
#   flydog-sdr:latest

FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive
ENV BRANCH=master

ADD entrypoint.sh /opt/entrypoint.sh

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y curl git iptables make rsync xxd \
    && curl -o /tmp/wiringpi.deb https://project-downloads.drogon.net/wiringpi-latest.deb \
    && dpkg -i /tmp/wiringpi.deb \
    && git clone -b ${BRANCH} https://github.com/flydog-sdr/FlyDog_SDR_GPS /root/Beagle_SDR_GPS \
    && cd /root/Beagle_SDR_GPS \
    && make \
    && make install \
    && rm -rf /root/Beagle_SDR_GPS/.git* /tmp/wiringpi.deb /var/lib/apt/lists/* \
    && echo 1 > /root/kiwi.config/_UPDATE \
    && chmod +x /opt/entrypoint.sh \


ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
