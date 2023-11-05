FROM golang:alpine AS builder

ENV GOPROXY="" \
    ALPINE_MIRROR="" \
    GIT_BRANCH="master" \
    GIT_HOST="github.com" \
    GIT_USER="flydog-sdr" \
    REPO_NANE="flycat-admin"

RUN if [ "x${ALPINE_MIRROR}" != "x" ]; then \
    sed "s/dl-cdn.alpinelinux.org/${ALPINE_MIRROR}/g" \
        -i /etc/apk/repositories; \
    fi \
    && apk add --no-cache git \
    && git clone --depth 1 --single-branch https://${GIT_HOST}/${GIT_USER}/${REPO_NANE} /flydog-admin \
    && cd /flydog-admin/cmd; CGO_ENABLED=0 GOOS=linux \
        go build -a -installsuffix cgo -o /tmp/admin *.go

FROM scratch
COPY --from=builder /tmp/admin /
CMD ["/admin", "-config", "/data/config.json"]
