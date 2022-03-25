FROM freeradius/freeradius-server:3.0.25-alpine

LABEL maintainer="eric.attou@wacren.net"

ARG RADIUSD_OPTIONS=sfxxl
ARG RADIUSD_LOGFILE=stdout
ENV RADIUSD_OPTIONS ${RADIUSD_OPTIONS}
ENV RADIUSD_LOGFILE ${RADIUSD_LOGFILE}

LABEL maintainer="eric.attou@wacren.net"

#WORKDIR /radius

RUN apk update && apk upgrade && \
    #apk add --update openssl freeradius-eap make && \
    #apk add --update openssl freeradius-eap freeradius-postgresql freeradius-mysql make && \
    rm /var/cache/apk/*
COPY radius/eap.conf /opt/etc/raddb/eap.conf
#RUN apk add ca-certificates

#RUN /opt/etc/raddb/certs/bootstrap && \
    #chmod -R +r /opt/etc/raddb/certs
#RUN cp /opt/etc/raddb/certs/server.pem /usr/local/share/ca-certificates/server.pem
#RUN update-ca-certificates 

#COPY radius/radiusd.conf /opt/etc/raddb/radiusd.conf
COPY radius/mods-config/attr_filter/pre-proxy /opt/etc/raddb/mods-config/attr_filter/pre-proxy
#COPY radius/mods-config/sql/ /etc/raddb/mods-config/sql/
COPY radius/mods-enabled/f_ticks /opt/etc/raddb/mods-enabled/f_ticks
COPY radius/sites-enabled/default /opt/etc/raddb/sites-enabled/default

EXPOSE 1812/udp 1813/udp

#CMD ["radiusd", "-${RADIUSD_OPTIONS}", "${RADIUSD_LOGFILE}"]
CMD radiusd -${RADIUSD_OPTIONS} -l ${RADIUSD_LOGFILE}
#CMD ["radiusd", "-sfl","stdout"]
