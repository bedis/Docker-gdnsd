# docker build --tag gdnsd --build-arg GDNS_VER=3.8.0 .

FROM alpine:latest AS build
MAINTAINER Baptiste Assmann <bedis9@gmail.com>

ARG GDNS_VER=

ENV GDNS_OPT="--prefix=/ --datarootdir=/usr"
ENV GDNS_BUILD_DEPENDENCY="perl perl-libwww ragel libev-dev autoconf automake libtool userspace-rcu-dev libcap-dev libmaxminddb-dev perl-test-harness perl-test-harness-utils libsodium-dev"

RUN apk update \
&& apk add gcc g++ make patch file openssl ${GDNS_BUILD_DEPENDENCY} \
&& addgroup -S -g 101 gdnsd \
&& adduser -S -H -D -u 100 -s /sbin/nologin gdnsd gdnsd \
&& mkdir /usr/src \
&& cd /usr/src \
&& wget https://github.com/gdnsd/gdnsd/releases/download/v${GDNS_VER}/gdnsd-${GDNS_VER}.tar.xz \
&& tar xJf gdnsd-${GDNS_VER}.tar.xz \
&& cd gdnsd-${GDNS_VER} \
&& autoreconf -vif \
&& ./configure ${GDNS_OPT} \
&& make \
&& make install

RUN find / -name gdnsd \
&& ls -l /var/lib

FROM alpine:latest

RUN apk --no-cache add libev libsodium libmaxminddb userspace-rcu libcap

COPY --from=build /etc/gdnsd      /etc/gdnsd
COPY --from=build /libexec/gdnsd  /libexec/gdnsd
COPY --from=build /usr/doc/gdnsd  /usr/doc/gdsnd
COPY --from=build /var/lib/gdnsd  /var/lib/gdnsd
COPY --from=build /sbin/gdnsd     /sbin/gdnsd
COPY --from=build /run/gdnsd      /run/gdnsd

RUN find / -name gdnsd

ENTRYPOINT [ "/sbin/gdnsd", "-f", "start" ]
