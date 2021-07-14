#FROM debian:buster-slim
FROM registry.cn-shanghai.aliyuncs.com/flydog-sdr/debian:latest AS builder
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ENV APT_MIRROR="" \
    DEBIAN_FRONTEND=noninteractive

RUN if [ "x${APT_MIRROR}" != "x" ]; then \
      sed -e "s/security.debian.org/${APT_MIRROR}/g" \
          -e "s/deb.debian.org/${APT_MIRROR}/g" \
          -i /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get install --no-install-recommends -y upx-ucl wsjtx \
    && mkdir /tmp/wsjtx \
    && cp /usr/bin/jt9 /tmp/wsjtx \
    && cp /usr/bin/wsprd /tmp/wsjtx \
    && upx --lzma /tmp/wsjtx/* \
    && apt-get autoremove --purge -y upx-ucl wsjtx

#FROM debian:buster-slim
FROM registry.cn-shanghai.aliyuncs.com/flydog-sdr/debian:latest
ENV APT_MIRROR="mirrors.bfsu.edu.cn" \
    DEBIAN_FRONTEND=noninteractive

ADD files.tar.gz /
COPY --from=builder /tmp/wsjtx/* /usr/bin/

RUN if [ "x${APT_MIRROR}" != "x" ]; then \
      sed -e "s/security.debian.org/${APT_MIRROR}/g" \
          -e "s/deb.debian.org/${APT_MIRROR}/g" \
          -i /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get install --no-install-recommends -y libfftw3-bin libqt5core5a python3 python3-numpy python3-requests

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]
