# [PagerMon]([https://hrng.io/](https://github.com/pagermon/pagermon)https://github.com/pagermon/pagermon)
## PagerMon SERVER install 

> [!NOTE]
> This guide assumes all instrucations from install_steps has been taken, and you are adding in a seconday instace
>
> There are two options below 
> 1. Is for a full second installation with both the Web Server and Reader being duplicated
> 2. Is for an additional *reader* that feeds to an existing Web Server

## Installing Pagermon 
This assumes that the existing installation of PagerMon is in the `/pagermon` folder of the user (eg: `~/pagermon` ) and the new instance will be in `~/pagermon2`

1. Clone PagerMon from Git into `~\pagermon2`
```
git clone https://github.com/pagermon/pagermon.git ~/pagermon2
```

> [!TIP]
> From here: 
>   * Go to the _Configuring the Server_ if installing the Server (or Server & Client)
>   * Go to the _Configuring the Client_ if installing the Client

## Configuring the Server 

> [!NOTE] 
> If you are doing a re-install and have any other customisations for the Server, now is the time to add them
1. Create and edit the Process.json file.
- Create a copy of the default file 
```
cp $HOME/pagermon2/server/process-default.json $HOME/pagermon2/server/process.json
```

- Open the file using your favourite editor - for the purposes of this guide we will use nano
```
nano $HOME/pagermon/server/process.json
```

- Edit line 2 to match your environment. (In this case, we're naming is pagermon2, but it can be anything distinctive you choose - this will also need to be updated in the package.json file, see steps below) 
```
"name"             : "pagermon2",
```

- Edit line 3 to match your environment.
```
"cwd"              : "/home/$USER/pagermon2/server",
```

- Edit Line 22 to your domain name (if desired)
   
```
"HOSTNAME": "pagermon2home.local",
```

> [!NOTE] 
> Adding a Hostname can cause an issue where you will be unable to log in to the web server. If this occurs, return to this file and change the line to read
>
> `"HOSTNAME": "",`
> 
> One completed, you will need to restart the server using `PM2 RESTART PAGERMON2`

> [!CAUTION] 
> This fix MAY NOT WORK and you may still not be able to log in. If this occurs, you will need to remove Pagermon and start again.
> 
> Make sure you have copied any customisations you want to keep
> 
> `cd ~ && sudo rm -r pagermon2`
> 
> Then return to step 6 above and repeat, but **_do NOT_** add a Hostname

- Edit line 24 - we also need to add a comma as we're putting a new line in

```
"APP_NAME": "pagermon2",
```

- At the end of line 24, hit _enter_ to create a new line, and add the following. The Port Number entered here is the port number that the second PagerMon instance will be available from once it's started	
```
"PORT": 3001
```
 * Save the file by using the hotkey CTRL-O, close the file by pressing CTRL-X.

> [!NOTE] 
> Adding the Port Number here _**may**_ not work - you'll know this, as when starting the app it is not accessible using Port 3001, but it **is** available on Port 3000 (or only the existing running instance is)
> If this is the case, you will need to edit *app.js* and set the updated port number on line 94
> Change `var port = normalizePort(process.env.PORT || '3000');` to `var port = normalizePort(process.env.PORT || '3001');`

  
> [!CAUTION] 
> Steps 2 and 3 are _optional_. They are added here because I had some issues with some of the nodes not installing correctly, and this helped resolve the issue
> I suggest skipping these steps, and only returning to here if the node installing has errors or the Client fails due to missing files etc
2. Navigate to /pagermon2/server directory and delete the node_modules folder if present and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)

```
cd /pagermon2/server &&\
rm -r node_modules
```

3. Copy the Node Modules files from the utilities repo
  * Copy the file from GitHub, rename and extract, then delete the zip file
```
wget https://github.com/bullseye555/pagermon_utilities/raw/refs/heads/main/pagermon_clean_install/node_modules_SERVER.tar.gz &&\
mv node_modules_SERVER.tar.gz node_modules.tar.gz &&\
tar -xvzf node_modules.tar.gz &&\
rm node_modules.tar.gz
```

4. Update the name of the program in the package.json file
  * Open the JSON file for editing
```
nano package.json
```

  * Edit line 2 - this name should match the name as edited on line 2 of process.json
```
"name": "pagermon2",
```

   * Save the file by using the hotkey CTRL-O, close the file by pressing CTRL-X.
5. Perform the Install of the NPM & ddependencies
```
sudo npm install -g node-pre-gyp &&\
sudo npm install sqlite3@5.0.0 &&\
sudo npm install -e NODE_OPTIONS='--max-old-space-size=2048'
```

> [!CAUTION] 
> This NPM Audit Fix (step 6) is _**OPTIONAL**_. If you do a clean install and find dependency errors, repeat this clean-install process but do NOT complete this step
> A clean install of Linux may be required to fully clear any installed dependencies (or do some Google-fu to find out how to remove the installed nodes)
6. Audit & and fix most NPM issues
```
sudo npm audit fix
```

7. Finalise and set the node as Production (Live)
```
export NODE_ENV=production
```


> [!TIP]
> From here: 
>   * If you are copying an existing database across, now is the time to do it
>   * Go to the _Pagermon Themes install_ if installing my themes
>   * Go to the _Configuring the Client_ if installing the Client
>   * Go to _Start Server_ if not running the client

## Pagermon Themes install
> [!NOTE]
> If you have already added the themes to the existing Server, skip straight to step 3
1. Create the git folder from the home directory and navigate to it
```
mkdir ~/git &&\
cd ~/git/
```
2. Clone the repo

`git clone https://github.com/bullseye555/pagermon_themes`

3. Copy the folder from Git to the Server Themes folder and remove the ReadMe file & .git folder
 -- Make sure you type "y" to accept any file deletion warnings
```
cp -a ~/git/pagermon_themes/. ~/pagermon2/server/themes/ &&\
rm ~/pagermon2/server/themes/README.md &&\
rm -r ~/pagermon2/server/themes/.git
```

> [!TIP]
> From here: 
>   * Go to the _Configuring the Client_ if installing the Client
>   * Go to _Start Server_ if not running the client

## Configuring the Client
1. Navigate to the Client directory
```
cd ~/pagermon2/client
```

3. Edit the name of the application in package.json
  * Open the JSON file for editing
```
nano package.json
```

  * Edit line 2 - this name should match the name as edited on line 2 of process.json
```
"name": "pagermon2-client",
```

   * Save the file by using the hotkey CTRL-O, close the file by pressing CTRL-X.
  
> [!CAUTION] 
> Steps 3 and 4 are _optional_
3. Navigate to /pagermon2/client directory delete the node_modules folder if present and copy in the contents of node_modules_SERVER.tar.gz (after extracting from the archive)
```
cd ~/pagermon2/client &&\
rm -r node_modules
```
4. Copy the Node Modules files from the utilities repo
  * Copy the file from GitHub, rename and extract, then delete the zip file
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

> [!TIP]
> From here: 
>   * Go to _Start Server_ if running the server (or Client & Server)
>   * Go to _Start Client_ if only running the client

## Start Pagermon Server [Web Host]
1. Navigate to the Server folder
```
cd ~/pagermon2/server/
```

3. Start process.json
```
pm2 start process.json
```

3. Save the PM2 config
```
pm2 save
```

5. Set PM2 to run at startup
```
sudo pm2 startup
```


> [!TIP]
> From here: 
>   * Go to _Start Client_  if running the Client
>   * Go to _PM2 Start_ if not running the client

## Start PagerMon Client [Message Decoder]
Before running Pagermon Client you have to configure it to send the decoded info to the pagermon server.
1. Copy default.json to config.json
```
cd ~/pagermon2/client/ &&\
cp config/default.json config/config.json 
```
2. Edit config.json with your favorite editor.
> [!NOTE] 
> At this point, if you are using a single Server, you can either create a NEW API Key [recommended] (make sure you don't delete the old one, or the exising Client will stop working!); or use the existing API key
   * Update the default API Key by accessing the server, eg: 192.168.1.10:3001, (Your IP may differ, use the port that you configured while setting up the server). Login and navigate to Settings and find then delete the fake APIs and create new APIs. Make sure you save!
   * Copy the new API key to config.json and make any other updates accordingly
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
cd ~/pagermon2/client/
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

3. Once this is run, it may give you a scrip that looks a bit like this that you need to run
```
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u bullseye --hp /home/bullseye
```

The _bullseye_ will be replaced with your login username for Linux
3. Copy it, and then run it
