# [PagerMon]([https://hrng.io/](https://github.com/pagermon/pagermon)https://github.com/pagermon/pagermon)
## PagerMon SERVER install 

1. Update the installed applications
```
sudo apt-get update &&\
sudo apt-get upgrade &&\
sudo apt update &&\
sudo apt upgrade 
```
2. Install NVM
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

3. Install NodeJS
Note: Updates to NodeJS and 
```
sudo curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```
4. Install SQLite3 & Git
```
sudo apt-get install sqlite3 git
```

6. Using NPM, install the latest NPM and PM2
```
sudo npm install npm@latest -g &&\
sudo npm install pm2@latest -g
```
6. Clone PagerMon from Git
```
cd ~ &&\
git clone https://github.com/pagermon/pagermon.git
```

8. Navigate to the Pagermon Server folder, and install node-pre-gyp and latest SQLite3
```
cd ~/pagermon/server &&\
sudo npm install -g node-pre-gyp &&\
sudo npm install sqlite3@latest
```
You may get a warning around **packages looking for funding**, this can be ignored and move onto the next step

> [!CAUTION] 
> Steps 8 and 9 are _optional_. They are added here because I had some issues with some of the nodes not installing correctly, and this helped resolve the issue
> I suggest skipping these steps, and only returning to here if the node installing has errors or the Client fails due to missing files etc
8. Whilst in /pagermon/server directory delete the node_modules folder if present and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)
```
rm -r node_modules
```

9. Copy the Node Modules files from the utilities repo
  * Copy the file from GitHub, rename and extract, then delete the zip file
```
wget https://github.com/bullseye555/pagermon_utilities/raw/refs/heads/main/pagermon_clean_install/node_modules_SERVER.tar.gz &&\
mv node_modules_SERVER.tar.gz node_modules.tar.gz &&\
tar -xvzf node_modules.tar.gz &&\
rm node_modules.tar.gz
```

> [!NOTE] 
> If you are doing a re-install and have any other customisations for the Server, now is the time to add them
10. Create and edit the **Process.json** file.
   * Create a copy of the default file  
```
cp $HOME/pagermon/server/process-default.json $HOME/pagermon/server/process.json
```

   * Open the file using your favourite editor - for the purposes of this guide we will use nano.
```
nano $HOME/pagermon/server/process.json
```

   * Edit line 3 to match your environment.
```
"cwd"              : "/home/$USER/pagermon/server",
```

   * Edit Line 22 to your domain name (if desired) [**WARNING** See the NOTE and CAUTION below about adding a hostname]
```
"HOSTNAME": "pagermonhome.local",
```
   * Save the file by using the hotkey CTRL-O, close the file by pressing CTRL-X.

> [!NOTE] 
> Adding a Hostname can cause an issue where you will be unable to log in to the web server. If this occurs, return to this file and change the line to read
>
> `"HOSTNAME": "",`
> 
> One completed, you will need to restart the server using `PM2 RESTART PAGERMON`

> [!CAUTION] 
> This fix MAY NOT WORK and you may still not be able to log in. If this occurs, you will need to remove Pagermon and start again.
> 
> Make sure you have copied any customisations you want to keep
> 
> `cd ~ && sudo rm -r pagermon`
> 
> Then return to step 6 above and repeat, but **_do NOT_** add a Hostname

11. Perform the Install of the NPM dependencies
```
sudo npm install -e NODE_OPTIONS='--max-old-space-size=2048'
```

> [!CAUTION] 
> This NPM Audit Fix (step 12) is _**OPTIONAL**_. If you do a clean install and find dependency errors, repeat this clean-install process but do NOT complete this step
> A clean install of Linux may be required to fully clear any installed dependencies (or do some Google-fu to find out how to remove the installed nodes)
12. Audit & and fix most NPM issues
```
sudo npm audit fix
```

13. Finalise and set the node as Production (Live)
```
export NODE_ENV=production
```


> [!TIP]
> From here: 
>   * Go to the _Themes Install_ if installing my themes
>   * Go to the _Client Install_ if installing/using the Client
>   * Go to _Start Server_ if not running the client

## Pagermon THEMES install
1. Create the git folder from the home directory and navigate to it
```
mkdir ~/git &&\
cd ~/git/
```
2. Clone the repo

```
git clone https://github.com/bullseye555/pagermon_themes 
```

3. Copy the folder from Git to the Server Themes folder and remove the ReadMe file & .git folder
 -- Make sure you type "y" to accept any file deletion warnings
```
cp -a ~/git/pagermon_themes/. ~/pagermon/server/themes/ &&\
rm ~/pagermon/server/themes/README.md &&\
rm -r ~/pagermon/server/themes/.git
```

> [!TIP]
> From here: 
>   * Go to the _Client Install_ if installing the Client
>   * Go to _Start Server_ if not running the client

## Pagermon CLIENT install
> [!NOTE] 
> If you are **ONLY** installing the client, you will need to go to the PagerMon SERVER install guide at the top of the page, and perform steps 1 to 6 there, and then return to here and complete the rest of this process

> [!CAUTION] 
> Step 1 is only required if there are any existing SDR drivers installed. This is as there can be funky things happen if the wrong drivers are installed. 
> If there has been a clean environment (eg, a fresh install of Linux), then there will be no drivers and this step can be ignored
1. Remove old drivers
```
sudo apt purge ^librtlsdr &&\
sudo rm -rvf /usr/lib/librtlsdr* /usr/include/rtl-sdr* /usr/local/lib/librtlsdr* /usr/local/include/rtl-sdr* /usr/local/include/rtl_* /usr/local/bin/rtl_*
```
2. Install drivers
```
cd ~ &&\
sudo apt-get install libusb-1.0-0-dev git cmake pkg-config build-essential &&\
git clone https://github.com/rtlsdrblog/rtl-sdr-blog &&\
cd rtl-sdr-blog/ &&\
mkdir build &&\
cd build &&\
cmake ../ -DINSTALL_UDEV_RULES=ON &&\
make &&\
sudo make install &&\
sudo cp ../rtl-sdr.rules /etc/udev/rules.d/ &&\
sudo ldconfig &&\
echo 'blacklist dvb_usb_rtl28xxu' | sudo tee --append /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf
```
3. Install Multimon
```
cd ~ &&\
git clone https://github.com/EliasOenal/multimon-ng &&\
cd multimon-ng &&\
mkdir build &&\
cd build &&\
cmake .. &&\
make &&\
sudo make install
```

> [!CAUTION] 
> Steps 4 and 5 are _optional_. They are added here because I had some issues with some of the nodes not installing correctly, and this helped resolve the issue
> I suggest skipping these steps, and only returning to here if the node installing has errors or the Client fails due to missing files etc
4. Navigate to /pagermon/client directory delete the node_modules folder if present and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)
```
cd ~/pagermon/client &&\
rm -r node_modules
```
5. Copy the Node Modules files from the utilities repo
  * Copy the file from GitHub, rename and extract, then delete the zip
```
wget https://github.com/bullseye555/pagermon_utilities/raw/refs/heads/main/pagermon_clean_install/node_modules_CLIENT.tar.gz &&\
mv node_modules_CLIENT.tar.gz node_modules.tar.gz &&\
tar -xvzf node_modules.tar.gz &&\
rm node_modules.tar.gz
```
  
> [!NOTE] 
> If you are doing a re-install and have any other customisations for the Client, now is the time to add them
6. Update the reader.sh file as needed
   * Refer to the [multimon-ng](https://github.com/EliasOenal/multimon-ng) git repo for more information
   * The main Pagermon GitHub repo has a little bit of information available too - [Pagermon](https://github.com/pagermon/pagermon?tab=readme-ov-file#installing-pagermon-client) (Return to this guide at the _Configure Pagermon Client_ section of the Pagermon GitHub guide)

> [!TIP]
> From here: 
>   * Go to _Start Server_ if running the server (or Client & Server)
>   * Go to _Start Client_ if only running the client

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

> [!NOTE] 
> You may also want to setup Log rotation for PM2, too - this step is optional
5. Install PM2 Logrotae
```
pm2 install pm2-logrotate &&\
sudo pm2 logrotate -u user
```
6. Save the PM2 config
```
pm2 save
```
7. Login to the website
   * If you have a web browser on the device you're running Pagermon from, you can use `localhost:3000` or use `ifconfig` in the terminal to identify the IP address, and use the IP address in place of _localhost_ (eg: `192.168.1.100:3000`)
   * The default credentials are username: `admin` with password: `changeme`
9. Go to the Admin panel and update the admin password (or create yourself a new account!)
10. You will also need to generate at least 1 API Key for use in the Client (regardless of where the client is hosted). _Make sure you **save** in the bottom right corner when you update!_
     
> [!TIP]
> From here: 
>   * Go to _Start Client_  if running the Client
>   * Go to _PM2 Start_ if not running the client

## Start PagerMon Client [Message Decoder]
Before running Pagermon Client you have to configure it to send the decoded info to the pagermon server.
1. Copy default.json to config.json
```
cd ~/pagermon/client/ &&\
cp config/default.json config/config.json 
```
2. Edit config.json with your favorite editor.
   * Update the default API Key with the API created during the Server setup at step 10. If you don't have one, go to the Settings page of the Server and create an API key. _Make sure you save!_
   * Copy the new API key
   * Set the hostname (`localhost:3000` or whatever the destination URL is). Be sure to use HTTP / HTPPS as appropriate. URLs (such as github.com) are also acceptable here, not just IP address. Be sure to include the port number
   * Set an identifier. When logged in to the Server (or _Hide Source_ is not enabled) this will be the identifier of the source of the decoded messages
   * If you haven't already, update your reader.sh file accordingly and save 
3. Install the Client NPM dependencies
```
npm install -e NODE_OPTIONS='--max-old-space-size=2048'
```

> [!CAUTION] 
> This NPM Audit Fix (step 4) is _**OPTIONAL**_. If you do a clean install and find dependency errors, repeat this clean-install process but do NOT complete this step
> A clean install of Linux may be required to fully clear any installed dependencies (or do some Google-fu to find out how to remove the installed nodes)
4. Audit & and fix most NPM issues
```
sudo npm audit fix
```

5. Navigate to the Client folder
```
cd ~/pagermon/client/
```

7. Start reader.sh
```
pm2 start reader.sh
```

7. Save the PM2 config
```
pm2 save
```

9. Set PM2 to run at startup
```
sudo pm2 startup
```


## Set PM2 to run at start up
Using the `sudo pm2 startup` may not correctly set PM2 to start, so if you find that it's not auto-starting after a restart, run it without `sudo`
1. Run
```
pm2 startup
```

3. Once this is run, it may give you a script that looks a bit like this that you need to run
```
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u bullseye --hp /home/bullseye
```

The _bullseye_ will be replaced with your login username for Linux
3. Copy it, and then run it
