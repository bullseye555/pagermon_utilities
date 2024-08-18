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

# Copy the existing auth Log file with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
cp /home/pi/pagermon/server/logs/auth.log /home/pi/pagermon/server/logs/auth.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing auth Log file
truncate -s 0 /home/pi/pagermon/server/logs/auth.log

# Copy the existing db Log file with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
cp /home/pi/pagermon/server/logs/db.log /home/pi/pagermon/server/logs/db.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing db Log file
truncate -s 0 /home/pi/pagermon/server/logs/db.log

# Copy the existing http Log file with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
cp /home/pi/pagermon/server/logs/http.log /home/pi/pagermon/server/logs/http.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing http Log file
truncate -s 0 /home/pi/pagermon/server/logs/http.log

# Copy the existing pagermon Log file with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
cp /home/pi/pagermon/server/logs/pagermon.log /home/pi/pagermon/server/logs/pagermon.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing pagermon Log file
truncate -s 0 /home/pi/pagermon/server/logs/pagermon.log


#Delete any Pagermon generated logs older than 90 days
find /home/pi/pagermon/server/logs -name "*.log" -type f -mtime +90 -delete

# Copy the existing PM2 logs with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13) ** repeat this for each Reader
cp /home/pi/.pm2/logs/reader-error.log /home/pi/log/pm2_log/reader-error.$(date +\%Y\%m\%d\%H).log
cp /home/pi/.pm2/logs/reader-out.log /home/pi/log/pm2_log/reader-out.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing pagermon Log file
truncate -s 0 /home/pi/.pm2/logs/reader-out.log
truncate -s 0 /home/pi/.pm2/logs/reader-error.log

# Copy the existing PM2 logs with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13)
#cp /home/pi/.pm2/logs/reader2-error.log /home/pi/log/pm2_log/reader2-error.$(date +\%Y\%m\%d\%H).log
#cp /home/pi/.pm2/logs/reader2-out.log /home/pi/log/pm2_log/reader2-out.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing pagermon Log file
#truncate -s 0 /home/pi/.pm2/logs/reader2-out.log
#truncate -s 0 /home/pi/.pm2/logs/reader2-error.log

# Copy the existing PM2 logs with today's date and the hour in the format yyyymmddHH (HH is 24 hour time, so 1pm is 13) ** repeat this for each Reader
cp /home/pi/.pm2/pm2.log /home/pi/log/pm2_log/pm2.$(date +\%Y\%m\%d\%H).log
# Delete the contents of the existing pagermon Log file
truncate -s 0 /home/pi/.pm2/pm2.log

#Delete any PM2 generated logs older than 90 days
find /home/pi/pagermon/server/logs -name "*.log" -type f -mtime +90 -delete

#restart pagermon
pm2 start all

# Clear the Hourly/Daily/Maintenance cron logs older than 30 days
find /home/pi/log/pm2_cron -name "*.log" -type f -mtime +30 -delete
# Clear the PM2 logs older than 90 days
find /home/pi/log/pm2_log -name "*.log" -type f -mtime +90 -delete
