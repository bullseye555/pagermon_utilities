# [PagerMon]([https://hrng.io/](https://github.com/pagermon/pagermon)https://github.com/pagermon/pagermon)
## Pagermon Utilities

This utilities suite has been created with some simple maintenance in mind, and a follow-the-bouncing-ball to do a clean install of PagerMon (as there were some... irregularities when I did it in early 2024)

Note that all data cleansing is as per decodes performed in Victoria, Australia, and your specific circumstances may vary! The owner & collaborators of this repository hold no responsibility for messages that have been deleted by using the scripts in this repository without reviewing and (where appropriate) updating requirements

All SQL queries/routines are based on SQLite3 being the database in use, and scripts may require updating for MySQL or Oracle

## Data Cleanup
Clean up junk decode data
* Specifically, any decodes that don't start with:
  * @@
  * Hb
  * QD
  * )&
  * Any decode that is _less than_ 10 characters in length
* See the _hourly_decode_cleanup.sql_ file for the query

### Instructions
1. Place the _hourly_decode_cleanup.sql_ file in a location of your choice. Location of the database file is in _/home/pi/pagermon/server _for this guide

    * If the location differs to that of _/home/pi/pagermon/server_, be sure to update the location inside the SQL file

2. Create a Crontab job to schedule the cleanup job (see the crontab file for more details)

    * You may use a different Scheduler if you want
    
    * Make sure you update the location accordingly if your _hourly_decode_cleanup.sql_ file is not in _/home/pi/pagermon/server_
  
    * A log of any outputs is set to generate to /home/pi/log/pm2_cron - be sure to create this location, update the output location, or delete **>/home/pi/log/pm2_cron/hourly_$(date +\%Y\%m\%d\%H\%M).log 2>&1** if you do not wish to generate an log output
  

## Data Archiving / Deletion
1. Migrate old data from the main _messages.db_ file to an archive file - this can be anywhere on the same Pagermon server and could be just a file for archiving purposes and accessed via SQLite3, or a second intance of Pagermon; OR
2. Delete older decodes from the main database without migrating to an archive file
   
Archiving to another database file assumes some knowledge, and that the secondary database has been setup
> [!NOTE]
> 1. The Archiving Job has two date ranges in it. 
>    * The first is _>30_ - this will archive and delete from **messages.db** any message that is _**older than**_ 30 days from the date the job is run
>    * The second is _>730_ - this will delete from the **archive** database any message that is _**older than**_ 730 days from the date the job is run

> [!IMPORTANT]
> 1. The Delete Job has one date range in it. 
>    * The first is _>30_ - this will delete from **messages.db** any message that is _**older than**_ 30 days from the date the job is run


### Instructions
1. Choose between the _Archive_ and _Delete_ SQL files and place the file in a location of your choice. Location of the database file is in _/home/pi/pagermon/server _for this guide

    * If the location differs to that of _/home/pi/pagermon/server_, be sure to update the location inside the SQL file
  
    * If using the _Archive_ file, update the destination location and name where appropriate
  
2. Create a Crontab job to schedule the cleanup job (see the crontab file for more details)
   
    * You may use a different Scheduler if you want
   
    * Make sure you update the location accordingly if your _old_decodes.sql_ file is not in /home/pi/pagermon/server
  
    * A log of any outputs is set to generate to /home/pi/log/pm2_cron - be sure to create this location, update the output location, or delete **>/home/pi/log/pm2_cron/daily_$(date +\%Y\%m\%d\%H\%M).log 2>&1** if you do not wish to generate an output
  

## Log Cleanup
Cleaup the Pagermon Log Files
* Specifically
  * Weekly archive of node-app.stdout.log
  * Weekly archive of node-app.stderr.log
  * Weekly archive of pagermon.log
  * Delete any _.log_ files in /home/pi/pagermon/server/logs that are older than 30 days

** **This job will stop stop Pagermon when it is running, to ensure Logs aren't being altered during processing** **


### Instructions
** **NOTE: GitHub changes the new-line end to CRLF from LF - Be sure to follow setp 2 to convert it back to UNIX** **
1. Place the _pagermon_maintenance.sh_ file in a location of your choice. Existing location in the /home/pi/pagermon folder

    * If the location differs to that of /home/pi/pagermon update the location inside the sh file
  
2. Conver the sh file back to UNIX new-line LF from CRLF by executing **dos2unix pagermon_maintenance.sh** 

    * If the location differs to that of /home/pi/pagermon make sure to navigate to the correct folder
	
3. Create a Crontab job to schedule the cleanup job (see the crontab file for more details)
   
    * You may use a different Scheduler if you want
    
    * Make sure you update the location accordingly if your _pagermon_maintenance.sh_ file is not in /home/pi/pagermon/server
   
    * A log of any outputs is set to generate to /home/pi/log/pm2_cron - be sure to create this location, update the output location, or delete **>/home/pi/log/pm2_cron/hourly_$(date +\%Y\%m\%d\%H\%M).log 2>&1** if you do not wish to generate an output
   

## Clean Install notes
### Clean Install for a single instance
In the pagermon_clean_install sub-folder of this repo is **install_steps.sh**

These are the steps that I followed, noted as in the order I did them (or at least, in the order I **SHOULD** have done them!), to now be running my PagerMon instance without issue - so it may seem like there's some redunancy (like installing SQLite3, then forcing v5.0.0 6 steps later...), but this is all becuase I ran into issues at the NPM Install phase, and found these were the ways that I had to resolve the issues.
One of the issues was regarding missing files during install, which - no matter what I tried - I couldn't get to run correctly. So in a moment of inspired madness, I copied over the node_modules folder I had backed up from the original instance I was using (which was the PagerMon Pi Image) and then it all worked...

1. Follow the script step by step
    * Don't forget that any line that ends with **&&\\** means that it's a "line-break" in the script, and whatever the following line is will need to be copied too
3. Be sure to replace the node_modules folders before performing the npm install of either the Server or Client
    * If you attempt the install without copying the files in this repo and the install fails, I suggest deleting all the node_modules folders before adding the version from this repo

### Clean Install for multiple instances on the same device
While I'm not currently running multiple instances on the same device (I have in the past), I have put this guide together for those that wish to do it (I've had a couple of requests about it!)

There are a couple of different options
1. Running two (or more) instances of the Server (Web UI) and Client (message decoder), so that one instance is available on Port 3000 and the second is available on a different port (EG: 3001)
2. Running two (or more) instances of the Client, and feed both onto the same Server (Web UI)

## Node Red notes
1. Add **package.json** to the node-red folder, which is ~/.node-red by default
2. Install the follwing palettes

	* @node-red-contrib-themes/theme-collection
    
	* node-red-contrib-discord-advanced
    
	* node-red-contrib-google-oauth2
    
	* node-red-contrib-moment
    
	* node-red-dashboard
    
	* node-red-node-email
    
	* node-red-node-pushover

3. Import the **Pagermon NodeRed Flow.json**
4. Review and modify nodes accordingly - you will need to configure gmail and discord connections
