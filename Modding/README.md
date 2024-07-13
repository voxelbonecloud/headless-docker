# Modding Resonite Headless Container

## NOTE: As of writing this mods are currently broken under dotnet8

To mod the headless some changes need to be made to the default compose file. 

 1. The containers home directory needs to binded to either a named volume or host location to persist between container recreation to preserve the mod files
 2. ADDITIONAL_ARGUMENTS needs to be uncommented and used for loading the Modloader assembly

The below compose example covers the above and utilizes a single bind location on the host to store all required files under it for easy access. 
If you prefer to use docker named volumes use [modded-compose-volumes.yml](modded-compose-volumes.yml)

    services:
      headless:
        container_name: resonite-headless
        image: ghcr.io/voxelbonecloud/headless-docker:main 
        env_file: .env
        environment:
          CONFIG_FILE: Config.json
          ADDITIONAL_ARGUMENTS: -LoadAssembly "/home/container/Headless/Libraries/ResoniteModLoader.dll"
        tty: true
        stdin_open: true
        user: "1000:1000"
        volumes:
          - "/etc/localtime:/etc/localtime:ro"
          - "Path/youwant/to/bindtoo/Config:/Config:ro"
          - "Path/youwant/to/bindtoo/Logs:/Logs"
          - "Path/youwant/to/bindtoo:/home/container"
        restart: on-failure:5

For the **first run** leave ADDITIONAL_ARGUMENTS commented out as so. 

    environment:
      CONFIG_FILE: Config.json
      #ADDITIONAL_ARGUMENTS: -LoadAssembly "/home/container/Headless/Libraries/ResoniteModLoader.dll"
This allows the headless to setup the vanilla installation so it is ready for modding.
Follow mod instructions on the [ResoniteModLoader page](https://github.com/resonite-modding-group/ResoniteModLoader) adapting the instructions to your headless directory location or volume. 

