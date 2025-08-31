FROM alpine
LABEL org.opencontainers.image.source https://github.com/IvanJosipovic/vpn-socks-proxy

EXPOSE 1080

#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

RUN apk add -q --progress --no-cache --update openvpn dante-server wget ca-certificates unzip curl openssl

RUN mkdir -p /openvpn/

RUN	wget -q https://www.privateinternetaccess.com/openvpn/openvpn.zip -O /pia.zip && \
	unzip -q pia.zip -d /openvpn/pia

#RUN	wget -q https://configs.ipvanish.com/configs/configs.zip -O /ipvanish.zip && \
#	unzip -q ipvanish.zip -d /openvpn/ipvanish

RUN	wget -q https://privadovpn.com/apps/ovpn_configs.zip -O /privadovpn.zip && \
	unzip -q privadovpn.zip -d /openvpn/privadovpn

RUN	mkdir -p /openvpn/ghostpath && \
	wget -q https://ghostpath.com/servers/filegen/yul1.gpvpn.com/o -O /openvpn/ghostpath/yul1.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yul2.gpvpn.com/o -O /openvpn/ghostpath/yul2.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yul3.gpvpn.com/o -O /openvpn/ghostpath/yul3.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yyz1.gpvpn.com/o -O /openvpn/ghostpath/yyz1.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yyz2.gpvpn.com/o -O /openvpn/ghostpath/yyz2.ovpn && \
	wget -q https://ghostpath.com/servers/filegen/yvr1.gpvpn.com/o -O /openvpn/ghostpath/yvr1.ovpn

RUN echo tls-cipher "DEFAULT:@SECLEVEL=0" >> /openvpn/ghostpath/yul1.ovpn && \
    echo tls-cipher "DEFAULT:@SECLEVEL=0" >> /openvpn/ghostpath/yul2.ovpn && \
    echo tls-cipher "DEFAULT:@SECLEVEL=0" >> /openvpn/ghostpath/yul3.ovpn && \
    echo tls-cipher "DEFAULT:@SECLEVEL=0" >> /openvpn/ghostpath/yyz1.ovpn && \
    echo tls-cipher "DEFAULT:@SECLEVEL=0" >> /openvpn/ghostpath/yyz2.ovpn && \
    echo tls-cipher "DEFAULT:@SECLEVEL=0" >> /openvpn/ghostpath/yvr1.ovpn

RUN	apk del -q --progress --purge unzip wget && \
	rm -rf /*.zip

COPY ./app/ /app
COPY ./etc/ /etc

RUN chmod 500 /app/ovpn/run /app/init.sh /app/down.sh

#RUN echo 'nameserver 1.1.1.1' > /etc/resolv.conf

ENV FILTER="" \
	SHUFFLE="" \
	CONFIG="" \
	WORKING_DIR=""

CMD ["/app/ovpn/run"]
