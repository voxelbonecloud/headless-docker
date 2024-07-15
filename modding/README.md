# Modding Resonite Headless Container
When ENABLE_MODS is set to true the following changes will happen each time the container starts. 

1. All required folders such as RML_mods/libs/config will be created inside the Resonite installation and symlinked to the corresponding folders under /RML in the container.
2. Libraries folder will be created
3. The latest release of 0Harmony-Net8.dll and ResoniteModLoader.dll will be downloaded and placed into the correct folders.
4. The correct Load Assembly argument will be passed to Resonite

Mods can be disabled and enabled as required by changing the variable.

## Using Mods
To add mods copy your mod files to the correct folders to the location your RML folder is binded too. 

The default location for persistent volumes is /var/lib/docker/volumes on Linux or if you used a host bind mount it is the location you specified on the host. Portainer also offers a basic inbuilt volume file manager