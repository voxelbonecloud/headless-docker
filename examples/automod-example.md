# Auto Mod installation example with ipv6
This example will assume the following. 

- IPV6 is working on the host.
- You have Docker working and have a basic idea how to use it.

This example will also move all the required environmental variables into the compose file. If you are going to host multiple servers in the same stack its recommended to keep using the environmental file for the beta code and steam credentials. 

To get around not setting up IPV6 support in docker bridge networks we will be using host networking mode. This will allow resonite to bind to the host interface for opening ports and accepting traffic on the hosts ipv6 address directly.

```
services:
  headless:
    container_name: resonite-headless
    image: ghcr.io/voxelbonecloud/headless-docker:main 
    network_mode: host
    environment:
      CONFIG_FILE: Config.json
      STEAM_USER: YourSteamUsername
      STEAM_PASS: YourSteamPassword
      BETA_CODE: SteamBetaCode
      STEAM_BRANCH: headless
      LOG_RETENTION: 30
      ENABLE_MODS: true
      ENABLE_AUTO_MOD_UPDATE: true
      MOD_HeadlessTweaks: true
      MOD_StresslessHeadless: true
      MOD_ResoniteIPv6Mod: true
      #ADDITIONAL_ARGUMENTS:
    tty: true
    stdin_open: true
    user: "1000:1000"
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
      - "Headless_Configs:/Config"
      - "Headless_Logs:/Logs"
      - "RML:/RML"
    restart: on-failure:5
volumes:
  Headless_Configs:
  Headless_Logs:
  RML:
```

The above compose file can be found in in a ready to go yml here [automod-example.yml](automod-example.yml)