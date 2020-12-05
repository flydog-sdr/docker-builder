# pi@raspberrypi:~ $ docker network create -d bridge flydog-sdr
# pi@raspberrypi:~ $ git clone https://github.com/flydog-sdr/docker-builder docker-builder
# pi@raspberrypi:~ $ cd docker-builder/admin
# pi@raspberrypi:~/docker-builder/admin $ docker build -t admin:latest .
# pi@raspberrypi:~/docker-builder/admin $ docker run -d \
#   --name admin \
#   --network flydog-sdr \
#   --publish 3708:3708 \
#   --restart always \
#   --volume /usr/bin/docker:/usr/bin/docker \
#   --volume /var/run/docker.sock:/var/run/docker.sock \
#   --volume kiwi.config:/etc/kiwi.config \
#   admin:latest

FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y busybox cron curl jq \
    && rm -rf /var/lib/apt/lists/* \
    && curl --resolve raw.githubusercontent.com:443:151.101.88.133 -o /usr/bin/updater.sh https://raw.githubusercontent.com/flydog-sdr/customised-scripts/master/self-update.txt \
    && chmod +x /usr/bin/updater.sh \
    && echo "0 4 * * * /usr/bin/updater.sh" | crontab -

CMD ["/usr/sbin/cron", "-l", "2", "-f"]
