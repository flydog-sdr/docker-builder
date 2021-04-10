FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive
ENV GIT_BRANCH="master" \
    GIT_HOST="github.com" \
    GIT_USER="flydog-sdr" \
    REPO_NANE="FlyDog_SDR_GPS"

ADD entrypoint.sh /opt/entrypoint.sh

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl file git iptables make rsync upx-ucl \
    && curl -o /tmp/wiringpi.deb https://project-downloads.drogon.net/wiringpi-latest.deb \
    && dpkg -i /tmp/wiringpi.deb \
    && git clone -b ${GIT_BRANCH} https://${GIT_HOST}/${GIT_USER}/${REPO_NANE} /root/${REPO_NANE} \
    && cd /root/${REPO_NANE} \
    && make \
    && make install \
    && upx --lzma /usr/local/bin/kiwid \
    && echo 1 > /root/kiwi.config/_UPDATE \
    && cat /root/${REPO_NANE}/Makefile | head -2 | cut -d " " -f3 | tr -d "\n" > /root/kiwi.config/_VERSION \
    && apt-get autoremove --purge -y clang-7 git iptables make rsync upx-ucl \
    && rm -rf /root/${REPO_NANE}/* \
              /root/${REPO_NANE}/.??* \
              /root/build/*.bin \
              /tmp/wiringpi.deb \
              /var/lib/apt/lists/* \
    && chmod +x /opt/entrypoint.sh

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]
