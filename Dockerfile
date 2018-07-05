FROM debian:stretch-slim@sha256:aa33563fd6dc2b14e8cae20cc74f4581d4cb89a3952d87b4cab323707040f035

ENV STUNNEL_VERSION 5.48
ENV STUNNEL_TGZ_URL https://www.stunnel.org/downloads/stunnel-$STUNNEL_VERSION.tar.gz
ENV STUNNEL_TGZ_SHA256 1011d5a302ce6a227882d094282993a3187250f42f8a801dcc1620da63b2b8df

RUN depsRuntime=' \
    openssl \
		curl \
		ca-certificates \
	' \
	&& depsBuild=' \
    libssl-dev \
		gcc \
		g++ \
		make \
	' \
	set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $depsRuntime \
	&& apt-get install -y --no-install-recommends $depsBuild \
	&& rm -r /var/lib/apt/lists/* \
	&& curl -SL "$STUNNEL_TGZ_URL" -o stunnel-$STUNNEL_VERSION.tgz \
	&& echo "$STUNNEL_TGZ_SHA256 stunnel-$STUNNEL_VERSION.tgz" | sha256sum -c - \
	&& mkdir -p src/stunnel \
	&& tar -xvf stunnel-$STUNNEL_VERSION.tgz -C src/stunnel --strip-components=1 \
	&& rm stunnel-$STUNNEL_VERSION.tgz* \
	&& cd src/stunnel \
	&& ./configure \
	&& make \
	&& make install \
	&& cd ../../ \
	&& rm -r src/stunnel \
	&& apt-get purge -y --auto-remove $depsBuild
