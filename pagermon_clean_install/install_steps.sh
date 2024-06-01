##pagermon SERVER install 

sudo apt-get update

sudo apt-get upgrade

sudo apt update

sudo apt upgrade

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

sudo curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

sudo apt-get install sqlite3 git

sudo npm install npm@latest -g

sudo npm install pm2@latest -g

git clone https://github.com/pagermon/pagermon.git

cd ~/pagermon/server

sudo npm install -g node-pre-gyp
sudo npm install sqlite3@5.0.0

#### Whilst in /pagermon/server directory delete the node_modules folder if present and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)
#### Be sure to update any other customisations now

#### Next we'll need to create and edit our Process.json file.
#### Create a copy of the default file

cp $HOME/pagermon/server/process-default.json $HOME/pagermon/server/process.json

#### Open the file using your favourite editor vim/nano etc, for the purposes of this guide we will use nano.

nano $HOME/pagermon/server/process.json

#### Edit line 3 to match your environment.

"cwd"              : "/home/$USER/pagermon/server",

#### Edit Line 22 to your domain name (if desired)

"HOSTNAME": "pagermonhome.local",

Save the file by using the hotkey CTRL-O, close the file by pressing CTRL-X.


sudo npm install -e NODE_OPTIONS='--max-old-space-size=2048'

#### This NPM Audit Fix line is OPTIONAL. If you do a clean install and find dependency errors, repeat this clean-install process but do NOT complete this step
#### You may need to do a clean install of Linux (or do some Google-fu to find out how to remove the installed nodes)
sudo npm audit fix

export NODE_ENV=production

##pagermon THEMES install

mkdir ~/git

cd ~/git/

git clone https://github.com/bullseye555/pagermon_themes

cp -a ~/git/pagermon_themes/. ~/pagermon/server/themes/

##pagermon CLIENT install

cd ~
## The next two lines of commands are removing any existing SDR drivers, as there can be funky things happen if the wrong drivers are installed. 
## If you know you need the drivers that are currently installed, skip these two command lines

sudo apt purge ^librtlsdr

sudo rm -rvf /usr/lib/librtlsdr* /usr/include/rtl-sdr* /usr/local/lib/librtlsdr* /usr/local/include/rtl-sdr* /usr/local/include/rtl_* /usr/local/bin/rtl_*

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

cd ~

git clone https://github.com/EliasOenal/multimon-ng
cd multimon-ng
mkdir build
cd build
cmake ..
make
sudo make install

cd ~/pagermon/client

#### Whilst in /pagermon/client directory Delete the node_modules folder if present and copy in the contents of node_modules_CLIENT.tar.gz (after extracting from the archive)
#### Be sure to update reader.sh, config/* and any other customisations now

## Start Pagermon Server [Web Host]

cd ~/pagermon/server/

pm2 start process.json

pm2 save

sudo pm2 startup

#### Before running Pagermon Client you have to configure it to send the decoded info to the pagermon server.
#### Copy default.json to config.json

cd ~/pagermon/client/

cp config/default.json config/config.json 

#### Edit config.json with your favorite editor.
#### Update the default API by accessing the server, eg: 192.168.1.10:3000, (Your IP may differ). Navigate to Settings and find then delete the fake APIs and create new APIs
#### Copy the new API key to config.json and make any other updates accordingly
#### Update your reader.sh file accordingly and save 

npm install -e NODE_OPTIONS='--max-old-space-size=2048'reader.sh

#### This NPM Audit Fix line is OPTIONAL. If you do a clean install and find dependency errors, repeat this clean-install process but do NOT complete this step
#### You may need to do a clean install of Linux (or do some Google-fu to find out how to remove the installed nodes)
sudo npm audit fix 

## Start Pagermon Client [Decoding]

pm2 start reader.sh

pm2 save

pm2 startup

## Set PM2 to run at start up
pm2 startup

## Once this is run, it may give you a scrip that looks a bit like this that you need to run
### sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u bullseye --hp /home/bullseye
## Copy it, and then run it
