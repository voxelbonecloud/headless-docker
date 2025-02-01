# Modding Resonite Headless Container
When `ENABLE_MODS` is set to true the following changes will happen each time the container starts. 

1. All required folders such as RML_mods/libs/config will be created inside the Resonite installation and symlinked to the corresponding folders under /RML in the container.
2. Libraries folder will be created
3. The latest release of 0Harmony-Net8.dll and ResoniteModLoader.dll will be downloaded and placed into the correct folders.
4. The correct Load Assembly argument will be passed to Resonite

Mods can be disabled and enabled as required by changing the variable.

## Using Mods
To add mods copy your mod files to the correct folders to the location your RML folder is bound to. 

The default location for persistent volumes is /var/lib/docker/volumes on Linux or if you used a host bind mount it is the location you specified on the host. Portainer also offers a basic inbuilt volume file manager
For example under volumes if you used - "/data/resomods:/RML" the mod folder would now be found on the host under /data/resomods/ 

## Automatically updating mods
You can automatically install / update a selected few mods:

- [HeadlessTweaks](https://github.com/New-Project-Final-Final-WIP/HeadlessTweaks)
- [StresslessHeadless](https://github.com/Raidriar796/StresslessHeadless)
- [ResoniteIPv6Mod](https://github.com/bontebok/ResoniteIPv6Mod)
- [Headless Prometheus Exporter](https://g.j4.lc/general-stuff/resonite/headless-prometheus-exporter)
- [HeadlessUserCulling}](https://github.com/Raidriar796/HeadlessUserCulling)

This functionality can be enabled with the `ENABLE_AUTO_MOD_UPDATE` environment variable.. Note `ENABLE_MODS` must also be `true`.

The individual mods have environment variables to install them: `MOD_HeadlessTweaks`, `MOD_StresslessHeadless`, `MOD_HeadlessUserCulling`, `MOD_PrometheusExporter` and `MOD_ResoniteIPv6Mod`.

**Keep in mind some mods can change the default behavior of the server**

For an example that automatically installs HeadlessTweaks, StresslessHeadless and the IPV6 Mod including enabling ipv6 passthrough [check this example](../examples/automod-example.md).