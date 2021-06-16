FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ENV APT_MIRROR="mirrors.bfsu.edu.cn" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo

ADD entrypoint.sh /opt/entrypoint.sh

RUN if [ "x${APT_MIRROR}" != "x" ]; then \
      sed -e "s/security.debian.org/${APT_MIRROR}/g" \
          -e "s/deb.debian.org/${APT_MIRROR}/g" \
          -i /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get install --no-install-recommends -y busybox ca-certificates cron curl jq \
    && export GITHUB_RAW_IP=$(curl -H 'accept: application/dns-json' \
                                   --connect-timeout 15 --retry 10 -s \
                                   'https://1.0.0.1/dns-query?name=raw.githubusercontent.com&type=A' | \
                                   jq -r '.Answer[2].data') \
    && curl --resolve raw.githubusercontent.com:443:${GITHUB_RAW_IP} \
            -o /usr/bin/updater.sh \
            https://raw.githubusercontent.com/flydog-sdr/customised-scripts/master/self-update.txt \
    && chmod +x /usr/bin/updater.sh \
                /opt/*.sh \
    && echo "0 4 * * * /usr/bin/updater.sh" >> /tmp/crontab \
    && crontab /tmp/crontab \
    && rm -rf /tmp/crontab /var/lib/apt/lists/*

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]
