FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ENV DEBIAN_FRONTEND=noninteractive \
    GIT_BRANCH="master" \
    GIT_HOST="github.com" \
    GIT_USER="flydog-sdr" \
    REPO_NANE="FlyDog_SDR_GPS"

ADD files.tar.gz /

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl file git iptables make rsync upx-ucl \
    && git clone --branch ${GIT_BRANCH} --depth 1 --single-branch https://${GIT_HOST}/${GIT_USER}/${REPO_NANE} /root/${REPO_NANE} \
    && cd /root/${REPO_NANE}; make; make install \
    && upx --lzma /usr/local/bin/kiwid \
    && apt-get autoremove --purge -y clang-7 git iptables make rsync upx-ucl \
    && rm -rf /root/${REPO_NANE}/* \
              /root/${REPO_NANE}/.??* \
              /root/build/*.bin \
              /var/lib/apt/lists/* \
    && ldconfig

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]
