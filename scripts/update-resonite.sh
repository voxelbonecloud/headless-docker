#!/bin/sh

if [ ! -d "/home/container/steamcmd" ]; then
	echo Installing steamcmd
	mkdir -p /home/container/steamcmd
	curl -sSL -o /tmp/steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
	tar -xf /tmp/steamcmd.tar.gz --directory /home/container/steamcmd
fi

HEADLESS_DIRECTORY="/home/container/Headless"

/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update 2519830 -beta ${STEAM_BRANCH} -betapassword ${BETA_CODE} +quit

#Mod installation if ENABLE_MODS is true. Heavily inspired and pulled from work by Spex. Thank you
if [ "${ENABLE_MODS}" = "true" ]; then

  # Create Libraries directory for RML to live in
  mkdir -p ${HEADLESS_DIRECTORY}/Libraries

  # Create RML directories on RML volume, mods and config will be stored in here.  
  mkdir -p /RML/rml_mods /RML/rml_libs /RML/rml_config
  
  # Symlink rml_mods, rml_libs and rml_config to where Resonite will read them.
  ln -s /RML/rml_mods ${HEADLESS_DIRECTORY}/rml_mods
  ln -s /RML/rml_libs ${HEADLESS_DIRECTORY}/rml_libs
  ln -s /RML/rml_config ${HEADLESS_DIRECTORY}/rml_config

  # Download RML and 0harmony
  curl -SslL https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/0Harmony-Net8.dll -o ${HEADLESS_DIRECTORY}/rml_libs/0Harmony-Net8.dll
  curl -SslL https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/ResoniteModLoader.dll -o ${HEADLESS_DIRECTORY}/Libraries/ResoniteModLoader.dll

fi

exec $*
