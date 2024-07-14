

# Resonite Headless 

Docker image based on Debian Bookworm Slim image with dotnet8 for hosting Resonite Headless servers. 

You can find examples for [Portainer deployments Here](portainer/)

## Before you start
You will require a steam beta code to gain access to the headless software. 
This can be done in game by sending `/headlessCode` to the Resonite bot in-game.
You will need a spare steam account that has Steam Guard disabled to run and download the server files.
You will need a config.json file for the headless to load. Examples for Resonite Headless config files can be found on the [Official Wiki](https://wiki.resonite.com/Headless_Server_Software/Configuration_File#Example_Files)

## Example Compose file
The following compose file uses stack wide environmental variables to set common values that may be used across multiple headless servers in the one stack. This allows adjusting config files for individual servers but reuse for example steam credentials for downloading server files.

For a version of the compose file not using the .env file then use [compose-noenv-example.yml](examples/compose-noenv-example.yml)

Example Compose file

    services:
      headless:
        container_name: resonite-headless
        image: ghcr.io/voxelbonecloud/headless-docker:main 
        env_file: .env
        environment:
          CONFIG_FILE: Config.json
          #ADDITIONAL_ARGUMENTS:
        tty: true
        stdin_open: true
        user: "1000:1000"
        volumes:
          - "/etc/localtime:/etc/localtime:ro"
          - "Headless_Configs:/Config:ro"
          - "Headless_Logs:/Logs"
        restart: on-failure:5
    volumes:
      Headless_Configs:
      Headless_Logs:

## Environmental Variables
Latest Environmental Variables can be found in [example.env](example.env)
Otherwise example below. 

    STEAM_USER="YourSteamUsername"
    STEAM_PASS="YourSteamPassword"
    BETA_CODE="SteamBetaCode"
    STEAM_BRANCH="headless"
    LOG_RETENTION="30"
LOG_RETENTION will default to 30 days if left unset or removed.

Additional variables are 

    CONFIG_FILE="Config.json"
    ADDITIONAL_ARGUMENTS=""
    
   However by default these two are defined inside the compose file itself so they can be adjusted on  a per-headless basis instead of an entire stack. If you prefer everything in the one .env file you can move them over.

## Using this image
This image by default stores the Config files and logs in named volumes that persist between container restarts/recreation. The cache and database are automatically cleared every restart of the headless or container. 
If you prefer to bind all the locations to a location on the host for easy management then use something like [compose-bindmount-example.yml](examples/compose-bindmount-example.yml)

The installation of the headless inside the container is wiped every time the container is deleted or updated so you can start fresh with a new container.
However if you are wanting to mod your headless server this behavior is not ideal. [Please read the modding section to change this.](modding)
