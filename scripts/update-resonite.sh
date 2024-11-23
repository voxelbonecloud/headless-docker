#!/bin/sh
# vim: ts=2 sw=2 et

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
  echo "Modding Headless files"

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

  # If automatic mod updating is enabled, download the requested mods
  if [ "${ENABLE_AUTO_MOD_UPDATE}" = "true" ]; then
    echo "Auto mod update is enabled. Downloading mods now"

    # HeadlessTweaks
    if [ "${MOD_HeadlessTweaks}" = "true" ]; then
      echo "Installing HeadlessTweaks"
      curl -SslL https://github.com/New-Project-Final-Final-WIP/HeadlessTweaks/releases/latest/download/HeadlessTweaks.dll -o ${HEADLESS_DIRECTORY}/rml_mods/HeadlessTweaks.dll
    fi

    # StresslessHeadless
    if [ "${MOD_StresslessHeadless}" = "true" ]; then
      echo "Installing StresslessHeadless"
      curl -SslL https://github.com/Raidriar796/StresslessHeadless/releases/latest/download/StresslessHeadless.dll -o ${HEADLESS_DIRECTORY}/rml_mods/StresslessHeadless.dll
    fi

    # ResoniteIPv6Mod
    if [ "${MOD_ResoniteIPv6Mod}" = "true" ]; then
      echo "Installing ResoniteIPv6Mod"
      curl -SslL https://github.com/bontebok/ResoniteIPv6Mod/releases/latest/download/ResoniteIPv6Mod.dll -o ${HEADLESS_DIRECTORY}/rml_mods/ResoniteIPv6Mod.dll
    fi

    # Headless Prometheus Exporter
    if [ "${MOD_PrometheusExporter}" = "true" ]; then
      echo "Installing Headless Prometheus Exporter"
      curl -SslL https://g.j4.lc/general-stuff/resonite/headless-prometheus-exporter/-/releases/1.2.1/downloads/HeadlessPrometheusExporter.dll -o ${HEADLESS_DIRECTORY}/rml_mods/HeadlessPrometheusExporter.dll
    fi

  fi

fi

#Pull github/git repository into staging folder if either ENABLE_GIT_CONFIG or ENABLE_GIT_MODS is set to true
if [ "${ENABLE_GIT_CONFIG}" = "true" ] || ["${ENABLE_GIT_MODS}" = "true" ]; then
  #Make the Staging folder for pulling down the repository
  mkdir -p /home/container/gitstaging
  cd /home/container/gitstaging
  if [ "${GIT_REPOSITORY_PRIVATE}" = "true" ]; then
    if [ -d ".git" ]; then
      # Pull Latest changes if repository already cloned
      git pull https://${GIT_USERNAME}:${GIT_ACCESS_TOKEN}@${GIT_URL#https://}
      echo "Repo has been pulled"
    else
      #If no existing files clone into staging directory. Keep the . at the end plz.
      git clone https://${GIT_USERNAME}:${GIT_ACCESS_TOKEN}@${GIT_URL#https://} .
      echo "Repo has been cloned"
    fi  
  else
    if [ -d ".git" ]; then
      # Pull Latest changes if repository already cloned
      git pull "${GIT_URL}"
      echo "Repo has been pulled"
    else
      #If no existing files clone into staging directory
      git clone "${GIT_URL}" .
      echo "Repo has been cloned"
    fi
  fi
fi

#If KEEP_IN_SYNC is true. The rml_mods, rml_config and the main /Config Folder will be wiped before coping the repo files. This ensures no additional files are added or kept.
#For example if you manually added a config file directly. This would be removed so everything is in sync with the repo. 
if [ "${KEEP_IN_SYNC}" = "true" ]; then
  rm -r /Config/*
  rm -r ${HEADLESS_DIRECTORY}/rml_config/*
  rm -r ${HEADLESS_DIRECTORY}/rml_mods/*
  echo "Deleted old files to stay in sync"
fi
#Copy Config files from git staging folder into /Config if ENABLE_GIT_CONFIG is true
if [ "${ENABLE_GIT_CONFIG}" = "true" ]; then
  cp -r config/*.json /Config
  echo "Config File copied from git staging folder"
fi

#Copy Mod files from git staging folder into correct folders if ENABLE_GIT_MODS is true and modding is enabled.
if [ "${ENABLE_GIT_MODS}" = "true" ] && [ "${ENABLE_MODS}" = "true" ]; then
  cp -r rml_mods/* ${HEADLESS_DIRECTORY}/rml_mods
  cp -r rml_config/* ${HEADLESS_DIRECTORY}/rml_config
  cp -r rml_libs/* ${HEADLESS_DIRECTORY}/rml_libs
  echo "Mod files copied from git staging folder"
fi

exec $*
