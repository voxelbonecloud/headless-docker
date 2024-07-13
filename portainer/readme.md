


# Portainer Setup

To use the compose files for Portainer the main change is simply replacing the env_file value with **stack.env**

## Example Stack

    services:
      headless:
        container_name: resonite-headless-dotnet8
        image: ghcr.io/voxelbonecloud/headless-docker:main 
        env_file: stack.env
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
To simply add the required environmental variables on the stack creation page. 
Click **Advanced mode** under the Environment variables section.
![portaineradvancemode](portainer/images/portainer-env.png)

Paste the contents of the [environment-portainer-examples](environment-portainer-examples) file straight into the text box that showed up. 
Swap back to simple mode and edit the values as required. 
