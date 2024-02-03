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

#### Delete the node_modules folder and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)
#### Be sure to update process.json and any other customisations now

sudo npm install -e NODE_OPTIONS='--max-old-space-size=2048'

sudo npm audit fix

export NODE_ENV=production

##pagermon THEMES install

mkdir ~/git

cd ~/git/

git clone https://github.com/bullseye555/pagermon_themes

cp -a ~/git/pagermon_themes/. ~/pagermon/server/themes/

##pagermon CLIENT install

cd ~

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
mkdir build
cd build
cmake ..
make
sudo make install

cd ~/pagermon/client

#### Delete the node_modules folder and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)
#### Be sure to update reader.sh, config/* and any other customisations now

npm install -e NODE_OPTIONS='--max-old-space-size=2048'reader.sh

sudo npm audit fix 

## Start Pagermon Server [Web Host]

cd ~/pagermon/server/

pm2 start process.json

pm2 save

sudo pm2 startup

## Start Pagermon Client [Decoding]

cd ~/pagermon/client/
pm2 start reader.sh
pm2 save
pm2 startup
