FROM debian:buster-slim
LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ARG DEBIAN_FRONTEND=noninteractive
ENV BRANCH=master

RUN sed -i "s/deb.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list \
  && sed -i "s/security.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y make git rsync iptables xxd \
  && git clone -b ${BRANCH} https://github.com/flydog-sdr/FlyDog_SDR_GPS /root/Beagle_SDR_GPS \
  && rm -rf /root/Beagle_SDR_GPS/.git*

RUN cd /root/Beagle_SDR_GPS \
  && make \
  && make install

RUN curl -o /tmp/wiringpi.deb https://project-downloads.drogon.net/wiringpi-latest.deb \
  && dpkg -i /tmp/wiringpi.deb \
  && rm -rf /tmp/wiringpi.deb

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
