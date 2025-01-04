

# Resonite Headless 

Docker image based on Debian Bookworm Slim image with dotnet8 for hosting Resonite Headless servers. Supports automatic modding of the Headless and updating config and mod files from git repos.

You can find examples for Portainer deployments in the [Portainer folder](portainer/)

For a basic setup guide, follow [setup.md](setup.md)

## Before you start

You will require a Steam beta code to gain access to the headless software.

This can be done in game by sending `/headlessCode` to the Resonite bot in-game. Currently to get access to the Headless server software you need to be a Resonite Patron at the "Discoverer" tier or above.

It is recommended to use a seperate Steam account with Steam Guard disabled to download the Headless software

You will need a config file for the headless to load. Examples for Resonite Headless config files can be found on the [Resonite Wiki](https://wiki.resonite.com/Headless_Server_Software/Configuration_File#Example_Files)

## Example Compose file
The following compose file uses stack wide environmental variables to set common values that may be used across multiple headless servers in the one stack. This allows adjusting config files for individual servers but reuse for example steam credentials for downloading server files.

For a version of the compose file not using the .env file then use [compose-noenv-example.yml](examples/compose-noenv-example.yml)
or check the [example list](examples/examples.md) we have for different requirements you may want.

```
services:
  headless:
    container_name: resonite-headless
    image: ghcr.io/voxelbonecloud/headless-docker:main 
    env_file: .env
    environment:
      CONFIG_FILE: Config.json
      ENABLE_MODS: false
      # ADDITIONAL_ARGUMENTS:
    tty: true
    stdin_open: true
    user: "1000:1000"
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
      - "Headless_Configs:/Config"
      - "Headless_Logs:/Logs"
      # - "RML:/RML" # Uncomment if using mods
    restart: on-failure:5
volumes:
  Headless_Configs:
  Headless_Logs:
  # RML: # Uncomment if using mods
```

## Environment Variables

The environment variables supported by this can be found in [example.env](example.env). Otherwise, they can be found below:

Required variables - These are all that are required for a headless server
```
STEAM_USER="YourSteamUsername"
STEAM_PASS="YourSteamPassword"
BETA_CODE="SteamBetaCode"
STEAM_BRANCH="headless"
```
Optional variables
```
LOG_RETENTION="30"
ENABLE_GIT_CONFIG="false"
ENABLE_GIT_MODS="false"
GIT_URL="URL"
GIT_REPOSITORY_PRIVATE="false"
GIT_USERNAME="username"
GIT_ACCESS_TOKEN="ACCESS-TOKEN"
KEEP_IN_SYNC="false"
```

LOG_RETENTION will default to 30 days if left unset or removed.


```
CONFIG_FILE="Config.json"
ADDITIONAL_ARGUMENTS=""
ENABLE_MODS="false"
```

By default, these are defined inside the container itself so they can be adjusted on a per-headless basis instead of on the entire stack.

This allows for you to mix and match unmodded servers within the same stack - an example of this can be found in [compose-multiple-servers-example.yml](examples/compose-multiple-servers-example.yml)

If you prefer, these can be moved to being stack wide variables in `.env`

## Important notes
To use ports configured with `forcePort` in the Resonite configuration, they must also be published by the Docker container. [compose-forceport-example.yml](examples/compose-forceport-example.yml) shows an example on how to publish ports.

By default, this image stores the Config files and logs in named volumes that persist between container restarts/recreation. 

The cache and database are automatically cleared every time either the headless or container are restarted, in order to keep disk usage down. 

If you prefer to bind all the locations to a location on the host for easy management then use something like [compose-bindmount-example.yml](examples/compose-bindmount-example.yml)

By default containers have no resource limits and will consume as much cpu and memory as needed. If you would like to set limits, refer to [compose-resourcelimits-example.yml](examples/compose-resourcelimits-example.yml)

## Enabling Mods

To enable mods, change the environment variable `ENABLE_MODS` to true. 

Copy your mod files into the corresponding folders inside the RML volume. Read our [Modding section](modding) for more info and how to use

## Enable Git Sync
On startup this headless can be configured to pull new or updated config files and mod files from Public/Private Git repos such as github. This allows you to move compose files around to different hosts easily, or quickly scale up additional headless with set configs or mods.

Additionally it allows easy tracking of changes and potentially make multi user access easier depending on your setup. The Headless just needs to be restarted for changes to be pulled down.

To configure this please visit the example template repo [found here](https://github.com/sveken/Headless-repo-template)
