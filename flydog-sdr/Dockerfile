#FROM debian:buster-slim
FROM registry.cn-shanghai.aliyuncs.com/flydog-sdr/debian:latest
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ENV APT_MIRROR="" \
    DEBIAN_FRONTEND=noninteractive \
    GIT_BRANCH="master" \
    GIT_HOST="github.com" \
    GIT_USER="flydog-sdr" \
    REPO_NANE="FlyDog_SDR_GPS"

ADD files.tar.gz /

RUN if [ "x${APT_MIRROR}" != "x" ]; then \
      sed -e "s/security.debian.org/${APT_MIRROR}/g" \
          -e "s/deb.debian.org/${APT_MIRROR}/g" \
          -i /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl file git iptables make rsync upx-ucl \
    && git clone --branch ${GIT_BRANCH} --depth 1 --single-branch https://${GIT_HOST}/${GIT_USER}/${REPO_NANE} /root/${REPO_NANE} \
    && sed -e "s#/etc/hosts#/dev/null#g" -i /root/${REPO_NANE}/Makefile \
    && cd /root/${REPO_NANE}; make; make install \
    && upx --lzma /usr/local/bin/kiwid \
    && apt-get autoremove --purge -y clang-7 cmake git make rsync upx-ucl \
    && rm -rf /root/${REPO_NANE}/* \
              /root/${REPO_NANE}/.??* \
              /root/build/*.bin \
              /var/lib/apt/lists/*

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]
