FROM ubuntu:20.04

LABEL maintainer="Nazmul Islam <naim.5221@gmail.com>"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:vbernat/haproxy-2.2 && \  
    apt-get install haproxy=2.2.\* rsyslog supervisor -y && \
    sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/haproxy && \
    mkdir -p /var/haproxy /var/log/haproxy /etc/supervisord.d && \
    touch /var/log/haproxy/haproxy.log /var/log/haproxy/haproxy-admin.log && \
    rm -rf /etc/rsyslog.d/49-haproxy.conf
    
# COPY ./conf/rsyslogs-haproxy.conf /etc/rsyslog.d/
COPY ./conf/logrotate-haproxy.conf /etc/logrotate.d/
COPY ./conf/supervisord-haproxy.conf /etc/supervisor/conf.d/
COPY ./conf/rsyslog.conf /etc/rsyslog.conf

RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf


CMD ["/usr/bin/supervisord"]
