# Setup Guide using Dockge

[Dockge](https://github.com/louislam/dockge) is an easy to use, self hosted docker compose manager that gives you an interactive web panel to easily manage compose files such as the one this project uses.

This Guide assumes you have a supported version of linux pre installed.

### Docker Installation
Official Docker installation instructions can be found at https://docs.docker.com/engine/install/

However for this guide we will be using the [get docker script](https://get.docker.com/) to auto install it for us, You can verify the script using the linked hyperlink. 

Using the script to auto install it run.

```
curl -fsSL https://get.docker.com -o install-docker.sh
```

Then run the script as root or with sudo. 

```
sudo sh install-docker.sh
```

Once this is finished you should be able to run ```docker version``` and it will output a result.



### Dockge Installation
This step is following the install guide found on the [Dockge Github](https://github.com/louislam/dockge)

First step is to create the directory the dockge compose file and its stacks will reside, then change the directory to this to work out of.
You may need to sudo these commands depending on the permission of the account you are using.
```
mkdir -p /opt/stacks /opt/dockge
cd /opt/dockge
```
Then download the Dockge compose file that will run.
```
curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml
```
Start the Dockge Server
```
docker compose up -d
```
Dockge is now running on port 5001 on the server. Example if it was your location machine it would be, http://localhost:5001

Load the dockge web interface, on installation it will prompt you to set up an admin account with a username and password. Please complete this. 

### Installing the Headless
Once logged into Dockge, Click the ```+ Compose``` button in the top left. 

In this example we are going to use the [no external environment compose file found here](examples\compose-noenv-example.yml).  Paste the contents of this file into the compose window on the right as per this picture. Also give your stack a name.

![Example Image of Dockge with pasted compose](\dockge\dockge-1.png)

