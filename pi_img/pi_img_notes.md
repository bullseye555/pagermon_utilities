This will require a 16GB (or larger) SD card for your Pi<br>
Due to the size, I can't upload it to here - so it's available for download from Google Drive (no sign in required) <a href="https://drive.google.com/file/d/1yDjg3cqsgejdHsxnBmh1tppfhZG45xUU/view?usp=sharing"> here</a><br>
Algorithm : SHA256<br>
Hash      : 055E19EAE87787BE950625FCD47C637CFCAF168A9AD728D17DB630C93239CBFE<br>
<br>
<br><b>Defaults:</b><br>
Raspberry Pi Username: Pi<br>
Raspberry Pi Password: raspberry<br>
PagerMon Server Username: admin<br>
PagerMon Server Password: changeme<br>
My PagerMon Themes from <a href="https://github.com/bullseye555/pagermon_themes"> here </a> have been installed, but the default PagerMon theme has been left as the enabled theme<br>
PM2 has <b>NOT</b> been configured to auto-start on boot<br>
<br>
PagerMon Client will need to be configured for your specific locaation - this is in the `/pagermon/client/reader.sh` file<br>
The current configuration works for my location in Victoria, Australia<br>
<br>

## Start Pagermon Server [Web Host]
1. Navigate to the Server folder
```
cd ~/pagermon/server/
```

3. Start process.json
```
pm2 start process.json
```

3. Save the PM2 config
```
pm2 save
```

4. Set PM2 to run at startup
```
sudo pm2 startup
```

## Start PagerMon Client [Message Decoder]
Before running Pagermon Client you have to configure it to send the decoded info to the pagermon server.
Edit the following file with the correct frequency (altering other settings as needed)
```
~/pagermon/client/reader.sh
```
1. Navigate to the Client folder
```
cd ~/pagermon/client/
```

2. Start reader.sh
```
pm2 start reader.sh
```

3. Save the PM2 config
```
pm2 save
```

4. Set PM2 to run at startup
```
sudo pm2 startup
```
