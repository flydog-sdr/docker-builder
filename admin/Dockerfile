FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

ADD entrypoint.sh /opt/entrypoint.sh

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y busybox ca-certificates cron curl jq \
    && export GITHUB_RWA_IP=$(curl -H 'accept: application/dns-json' \
                                   --connect-timeout 15 --retry 10 -s \
                                   'https://1.0.0.1/dns-query?name=raw.githubusercontent.com&type=A' | \
                                   jq -r '.Answer[2].data') \
    && curl --resolve raw.githubusercontent.com:443:${GITHUB_RWA_IP} \
            -o /usr/bin/updater.sh \
            https://raw.githubusercontent.com/flydog-sdr/customised-scripts/master/self-update.txt \
    && chmod +x /usr/bin/updater.sh \
    && echo "0 4 * * * /usr/bin/updater.sh" >> /tmp/crontab \
    && crontab /tmp/crontab \
    && rm -rf /tmp/crontab /var/lib/apt/lists/*

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
