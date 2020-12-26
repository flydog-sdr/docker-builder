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
