FROM alpine:3.5

ARG DOCKER_VERSION=17.09.1
ENV PROJECT_NAME="N/A"

# setup timezone for Europe/Kiev
RUN apk add --update tzdata bash curl \ 
    && cp /usr/share/zoneinfo/Europe/Kiev /etc/localtime \
    && echo "Europe/Kiev" > /etc/timezone \ 
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

# install docker client only
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}-ce.tgz \
  && tar xzvf docker-${DOCKER_VERSION}-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -rf docker docker-${DOCKER_VERSION}-ce.tgz


# Prepare log files, use mkfifo to avoid littering on container writeable layer
RUN mkfifo -m 0666 /var/log/cron.log

# Install crontab
COPY entrypoint.sh /usr/local/bin
COPY crontab /tmp/crontab
RUN /usr/bin/crontab -l \
    | (cat; cat /tmp/crontab) \
    | /usr/bin/crontab -

COPY renew_certs.sh /opt/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]