# [PagerMon]([https://hrng.io/](https://github.com/pagermon/pagermon)https://github.com/pagermon/pagermon)
## PagerMon SERVER install 

1. Update the installed applications
```
sudo apt-get update
sudo apt-get upgrade
sudo apt update
sudo apt upgrade
```
2. Install NVM

`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash`

3. Install NodeJS
```
sudo curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```
4. Install SQLite3 & Git

`sudo apt-get install sqlite3 git`

5. Using NPM, install the latest NPM and PM2
```
sudo npm install npm@latest -g
sudo npm install pm2@latest -g
```
6. Clone PagerMon from Git

`git clone https://github.com/pagermon/pagermon.git`

7. Navigate to the Pagermon Server folder, and install node-pre-gyp and SQLite3 v5.0.0
```
cd ~/pagermon/server
sudo npm install -g node-pre-gyp
sudo npm install sqlite3@5.0.0
```
> [!CAUTION] 
> Steps 8 and 9 are _optional_
8. Whilst in /pagermon/server directory delete the node_modules folder if present and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)

`rm -r node_modules`

9. Copy the Node Modules files from the utilities repo
   * Copy the file from GitHub, and then rename and extract
```
wget https://github.com/bullseye555/pagermon_utilities/raw/refs/heads/main/pagermon_clean_install/node_modules_SERVER.tar.gz
mv node_modules_SERVER.tar.gz node_modules.tar.gz
tar -xvzf node_modules.tar.gz
```
   * Delete the zip file
   
`rm node_modules.tar.gz`

> [!NOTE] 
> If you are doing a re-install and have any other customisations for the Server, now is the time to add them
10. Create and edit the Process.json file.
   * Create a copy of the default file
   
`cp $HOME/pagermon/server/process-default.json $HOME/pagermon/server/process.json`

   * Open the file using your favourite editor - for the purposes of this guide we will use nano.
   
`nano $HOME/pagermon/server/process.json`

   * Edit line 3 to match your environment.
   
`"cwd"              : "/home/$USER/pagermon/server",`

   * Edit Line 22 to your domain name (if desired)
   
`"HOSTNAME": "pagermonhome.local",`

> [!NOTE] 
> This can cause an issue where you will be unable to log in to the web server. If this occurs, return to this file and change the line to reader
>
> `"HOSTNAME": "",`

   * Save the file by using the hotkey CTRL-O, close the file by pressing CTRL-X.
11. Perform the Install of the NPM dependencies

`sudo npm install -e NODE_OPTIONS='--max-old-space-size=2048'`

> [!CAUTION] 
> This NPM Audit Fix (step 12) is _**OPTIONAL**_. If you do a clean install and find dependency errors, repeat this clean-install process but do NOT complete this step
> A clean install of Linux may be required to fully clear any installed dependencies (or do some Google-fu to find out how to remove the installed nodes)
12. Audit & and fix most NPM issues

`sudo npm audit fix`

13. Finalise and set the node as Production (Live)

`export NODE_ENV=production`


> [!TIP]
> From here: 
>   * Go to the _Themes Install_ if installing my themes
>   * Go to the _Client Install_ if installing the Client
>   * Go to _Start Server_ if not running the client

## Pagermon THEMES install
1. Create the git folder from the home directory and navigate to it
```
mkdir ~/git
cd ~/git/
```
2. Clone the repo

`git clone https://github.com/bullseye555/pagermon_themes`

3. Copy the folder from Git to the Server Themes folder

`cp -a ~/git/pagermon_themes/. ~/pagermon/server/themes/`


> [!TIP]
> From here: 
>   * Go to the _Client Install_ if installing the Client
>   * Go to _Start Server_ if not running the client

## Pagermon CLIENT install
0. Return to the home directory (only needed if you're not already there)

`cd ~`


> [!CAUTION] 
> Step 1 is only required if there are any existing SDR drivers installed. This is as there can be funky things happen if the wrong drivers are installed. 
> If there has been a clean environment (eg, a fresh install of Linux), then there will be no drivers and this step can be ignored
1. Remove old drivers
```
sudo apt purge ^librtlsdr
sudo rm -rvf /usr/lib/librtlsdr* /usr/include/rtl-sdr* /usr/local/lib/librtlsdr* /usr/local/include/rtl-sdr* /usr/local/include/rtl_* /usr/local/bin/rtl_*
```
2. Install drivers
```
sudo apt-get install libusb-1.0-0-dev git cmake pkg-config build-essential

git clone https://github.com/rtlsdrblog/rtl-sdr-blog

cd rtl-sdr-blog/
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo cp ../rtl-sdr.rules /etc/udev/rules.d/
sudo ldconfig
echo 'blacklist dvb_usb_rtl28xxu' | sudo tee --append /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf
```
3. Install Multimon
```
cd ~
git clone https://github.com/EliasOenal/multimon-ng
cd multimon-ng
mkdir build
cd build
cmake ..
make
sudo make install
```

> [!CAUTION] 
> Steps 4 and 5 are _optional_
4. Navigate to /pagermon/client directory delete the node_modules folder if present and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)
```
cd ~/pagermon/client
rm -r node_modules
```
5. Copy the Node Modules files from the utilities repo
   * Copy the file from GitHub, and then rename and extract
```
wget https://github.com/bullseye555/pagermon_utilities/raw/refs/heads/main/pagermon_clean_install/node_modules_CLIENT.tar.gz
mv node_modules_CLIENT.tar.gz node_modules.tar.gz
tar -xvzf node_modules.tar.gz
```
   * Delete the zip file
   
`rm node_modules.tar.gz`


> [!NOTE] 
> If you are doing a re-install and have any other customisations for the Client, now is the time to add them
6. Update the reader.sh file as needed
   * Refer to the [multimon-ng](https://github.com/EliasOenal/multimon-ng) git repo for more information

> [!TIP]
> From here: 
>   * Go to _Start Server_ if running the server (or Client & Server)
>   * Go to _Start Client_ if only running the client

## Start Pagermon Server [Web Host]
1. Navigate to the Server folder

`cd ~/pagermon/server/`

2. Start process.json

`pm2 start process.json`

3. Save the PM2 config

`pm2 save`

4. Set PM2 to run at startup

`sudo pm2 startup`


> [!TIP]
> From here: 
>   * Go to _Start Client_  if running the Client
>   * Go to _PM2 Start_ if not running the client

## Start PagerMon Client [Page Decoder]
Before running Pagermon Client you have to configure it to send the decoded info to the pagermon server.
1. Copy default.json to config.json
```
cd ~/pagermon/client/
cp config/default.json config/config.json 
```
2. Edit config.json with your favorite editor.
   * Update the default API Key by accessing the server, eg: 192.168.1.10:3000, (Your IP may differ). Login and navigate to Settings and find then delete the fake APIs and create new APIs. Make sure you save!
   * Copy the new API key to config.json and make any other updates accordingly
   * If you haven't already, update your reader.sh file accordingly and save 
3. Install the Client NPM dependencies

`npm install -e NODE_OPTIONS='--max-old-space-size=2048'reader.sh`

> [!CAUTION] 
> This NPM Audit Fix (step 4) is _**OPTIONAL**_. If you do a clean install and find dependency errors, repeat this clean-install process but do NOT complete this step
> A clean install of Linux may be required to fully clear any installed dependencies (or do some Google-fu to find out how to remove the installed nodes)
4. Audit & and fix most NPM issues

`sudo npm audit fix`

5. Navigate to the Client folder

`cd ~/pagermon/client/`

6. Start reader.sh

`pm2 start reader.sh`

7. Save the PM2 config

`pm2 save`

8. Set PM2 to run at startup

`sudo pm2 startup`


## Set PM2 to run at start up
Using the `sudo pm2 startup` may not correctly set PM2 to start, so if you find that it's not auto-starting after a restart, run it without `sudo`
1. Run

`pm2 startup`

2. Once this is run, it may give you a scrip that looks a bit like this that you need to run

`sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u bullseye --hp /home/bullseye`

The _bullseye_ will be replaced with your login username for Linux
3. Copy it, and then run it