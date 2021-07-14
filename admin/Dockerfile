#FROM debian:buster-slim
FROM registry.cn-shanghai.aliyuncs.com/flydog-sdr/debian:latest
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ENV APT_MIRROR="" \
    DEBIAN_FRONTEND=noninteractive

ADD entrypoint.sh /opt/entrypoint.sh

RUN if [ "x${APT_MIRROR}" != "x" ]; then \
      sed -e "s/security.debian.org/${APT_MIRROR}/g" \
          -e "s/deb.debian.org/${APT_MIRROR}/g" \
          -i /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get install --no-install-recommends -y busybox ca-certificates cron curl jq \
    && curl -o /usr/bin/updater.sh -fsSL bclswl0827.coding.net/p/flydog-sdr/d/api/git/raw/master/self-update.txt \
    && chmod +x /usr/bin/updater.sh \
                /opt/*.sh \
    && echo "0 4 * * * /usr/bin/updater.sh" >> /tmp/crontab \
    && crontab /tmp/crontab \
    && rm -rf /tmp/crontab /var/lib/apt/lists/*

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]
