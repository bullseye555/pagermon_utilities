# [PagerMon]([https://hrng.io/](https://github.com/pagermon/pagermon)https://github.com/pagermon/pagermon)
## Creating Crontab entries

This guide has been put together as a basic guide on creating a Crontab job (the base Linux scheduler)
> [!NOTE] 
> * Starting crontab may require elevated access using _sudo_ (Running as _sudo_ is recommended to ensure no access issues)
> * The first time you run this, it may ask you what editor to you. Select the editor accordingly

Crontab entries have multiple fields - a handy guide on Crontabs is available at [Admin's Choice](https://adminschoice.com/crontab-quick-reference/) and a useful tool to help generate a crontab is available at [Crontab Generator](https://crontab-generator.org/)

> [!IMPORTANT]
> If you are generating a log file, make sure the folder path exists (in the below examples, this is _/home/pi/log/pm2_cron_) as Linux will not create the folders if they don't already exists

## Basic Templates
1. Hourly decode cleanup
   * This job is set to run every hour, at 3 minutes past the hour (every hour), and output a logfile ending with the date, hour, and minute in the format yyyymmddHHMM (HH is 24 hour time, so 1pm would be displated as 13)
   * Remember to update or remove anything after the first **>** to change the location of the log file (or not log at all) 
```
03 */1 * * * sudo sqlite3 < /home/pi/pagermon/server/hourly_decode_cleanup.sql >/home/pi/log/pm2_cron/hourly_$(date +\%Y\%m\%d\%H\%M).log 2>&1
```

2. Daily decode **archiving**
   * This job is set to run day at 0007 (7 minutes past midnight), and output a logfile ending with the date, hour, and minute in the format yyyymmddHHMM (HH is 24 hour time, so 1pm would be displated as 13)
   * Remember to update or remove anything after the first **>** to change the location of the log file (or not log at all) 
```
07 00 * * * sudo sqlite3 < /home/pi/pagermon/server/archive_old_decodes.sql >/home/pi/log/pm2_cron/daily_$(date +\%Y\%m\%d\%H).log 2>&1
```

3. Daily decode **delete**
   * This job is set to run daily at 0007 (7 minutes past midnight), and output a logfile ending with the date, hour, and minute in the format yyyymmddHHMM (HH is 24 hour time, so 1pm would be displated as 13)
   * Remember to update or remove anything after the first **>** to change the location of the log file (or not log at all) 
```
07 00 * * * sudo sqlite3 < /home/pi/pagermon/server/delete_old_decodes.sql >/home/pi/log/pm2_cron/daily_$(date +\%Y\%m\%d\%H).log 2>&1
```

4. Weekly Pagermon log cleanup
   * This job is set to run at 0103 on Mondays (1:03am), and output a logfile ending with the date, hour, and minute in the format yyyymmddHHMM (HH is 24 hour time, so 1pm would be displated as 13)
   * Remember to update or remove anything after the **>>** to change the location of the log file (or not log at all) 
```
03 01 * * 1 sh /home/pi/pagermon/pagermon_maintenance.sh >> /home/pi/log/pm2_cron/maintenance_$(date +\%Y\%m\%d\%H).log 2>&1
```

## Creating a Job
1. In the Terminal, type `crontab -e` and, if needed select the editor you want to use
2. Navigate to the bottom of the file, past the last row that starts with a **#** (this is Crontab's _comment_ symbol) and enter/paste in the command for the job
   * In this example, the _Daily Decode **delete**_ is being used, with no logging
   * ![image](https://github.com/user-attachments/assets/47cf6a83-ea60-4e1c-b58b-3e41d123834c)
3. Save and exit the file, and the job has now been created
