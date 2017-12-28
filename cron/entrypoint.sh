#!/usr/bin/env bash

set -eux

# kill last background process (tail) and exit
# see Trapping signals in Docker containers – Grigorii Chudnov – Medium - https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86
# see https://github.com/renskiy/cron-docker-image
trap 'kill ${!}; exit' SIGTERM SIGINT

# Start cron daemon in background
crond -L /var/log/cron.log -l 2

# Tail logs from /var/log/cron.log fifo forever
while true 
do 
  cat /var/log/cron.log & wait ${!}
done 
