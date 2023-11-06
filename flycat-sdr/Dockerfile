FROM debian:bullseye-slim

ENV APT_MIRROR="" \
    DEBIAN_FRONTEND=noninteractive \
    GIT_BRANCH="master" \
    GIT_HOST="github.com" \
    GIT_USER="flydog-sdr" \
    REPO_NANE="FlyCat_SDR_GPS"

ADD files.tar.gz /

RUN if [ "x${APT_MIRROR}" != "x" ]; then \
      sed -e "s/security.debian.org/${APT_MIRROR}/g" \
          -e "s/deb.debian.org/${APT_MIRROR}/g" \
    -i /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl file git netpbm iptables make rsync \
    && git clone --branch ${GIT_BRANCH} --depth 1 --single-branch https://${GIT_HOST}/${GIT_USER}/${REPO_NANE} /root/${REPO_NANE} \
    && cd /root/${REPO_NANE}; make; make install \
    && rm -rf /root/build/*.bin /var/lib/apt/lists/*

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]
