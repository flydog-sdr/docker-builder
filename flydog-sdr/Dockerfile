FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive
ENV GIT_URL="github.com" \
    BRANCH=master \
    REPO=FlyDog_SDR_GPS

ADD entrypoint.sh /opt/entrypoint.sh

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl git iptables make rsync upx-ucl xxd \
    && curl -o /tmp/wiringpi.deb https://project-downloads.drogon.net/wiringpi-latest.deb \
    && dpkg -i /tmp/wiringpi.deb \
    && git clone -b ${BRANCH} https://${GIT_URL}/flydog-sdr/${REPO} /root/${REPO} \
    && cd /root/${REPO} \
    && make \
    && make install \
    && upx --ultra-brute /usr/local/bin/kiwid \
    && echo 1 > /root/kiwi.config/_UPDATE \
    && apt-get autoremove --purge -y ca-certificates clang-7 git iptables make rsync upx-ucl \
    && rm -rf /root/${REPO}/* \              
              /tmp/wiringpi.deb \
              /var/lib/apt/lists/* \
    && chmod +x /opt/entrypoint.sh

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
