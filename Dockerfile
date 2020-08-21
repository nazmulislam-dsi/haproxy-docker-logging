FROM ubuntu:20.04

LABEL maintainer="Nazmul Islam <naim.5221@gmail.com>"

RUN groupadd haproxy
RUN useradd -r -g haproxy -M -d /var/haproxy -s /sbin/nologin haproxy

#https://haproxy.debian.net/#?distribution=Ubuntu&release=focal&version=2.2
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:vbernat/haproxy-2.2
RUN apt-get update
RUN apt-get install haproxy=2.2.\* rsyslog supervisor -y
RUN sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/haproxy

RUN mkdir -p /var/haproxy /var/log/haproxy /etc/supervisord.d
RUN touch /var/log/haproxy/haproxy.log
RUN touch /var/log/haproxy/haproxy-admin.log
RUN chown -R syslog:adm /var/log/haproxy/

COPY rsyslogs-haproxy.conf /etc/rsyslog.d/
COPY logrotate-haproxy.conf /etc/logrotate.d/
COPY supervisord-haproxy.conf /etc/supervisor/conf.d/

RUN rm -rf /etc/rsyslog.d/49-haproxy.conf

CMD ["/usr/bin/supervisord"]