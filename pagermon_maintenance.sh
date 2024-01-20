#!/bin/bash

#stop pagermon so logs aren't altered during the process
pm2 stop all

# Copy the existing stdout Log file with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
cp /home/pi/pagermon/server/logs/node-app.stdout.log /home/pi/pagermon/server/logs/node-app.stdout.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing stdout Log file
truncate -s 0 /home/pi/pagermon/server/logs/node-app.stdout.log

# Copy the existing stderr Log file with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
cp /home/pi/pagermon/server/logs/node-app.stderr.log /home/pi/pagermon/server/logs/node-app.stderr.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing stderr Log file
truncate -s 0 /home/pi/pagermon/server/logs/node-app.stderr.log

# Copy the existing pagermon Log file with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
cp /home/pi/pagermon/server/logs/pagermon.log /home/pi/pagermon/server/logs/pagermon.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing pagermon Log file
truncate -s 0 /home/pi/pagermon/server/logs/pagermon.log

#Delete any Pagermon generated logs older than 30 days
find /home/pi/pagermon/server/logs -name "*.log" -type f -mtime +30 -delete

#restart pagermon
pm2 start all
