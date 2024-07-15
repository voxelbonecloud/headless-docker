#!/bin/sh

HEADLESS_DIRECTORY="/home/container/Headless/net8.0"

/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update 2519830 -beta ${STEAM_BRANCH} -betapassword ${BETA_CODE} +quit

# Fix for issue with NVR.json migrations exploding
ln -sf /home/container/Migrations /home/container/Headless/Migrations

#Mod installation if ENABLE_MODS is true. Heavily inspired and pulled from work by Spex. Thank you
if [ "${ENABLE_MODS}" = "true" ]; then

  # Create Libraries directory for RML to live in
  mkdir -p ${HEADLESS_DIRECTORY}/Libraries

  # Create RML directories on RML volume, mods and config will be stored in here.  
  mkdir -p /RML/rml_mods /RML/rml_libs /RML/rml_config
  
  # Symlink rml_mods, rml_libs and rml_config to where Resonite will read them.
  ln -sf /RML/rml_mods ${HEADLESS_DIRECTORY}/rml_mods
  ln -sf /RML/rml_libs ${HEADLESS_DIRECTORY}/rml_libs
  ln -sf /RML/rml_config ${HEADLESS_DIRECTORY}/rml_config

  # From: https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8?permalink_comment_id=5097031#gistcomment-5097031 
  # Fetch the latest release version number for ResoniteModLoader
  latest_version=$(curl -s https://api.github.com/repos/resonite-modding-group/ResoniteModLoader/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
  # Remove the 'v' prefix from the version number
  version=${latest_version#v}
  # Construct the download URLs for RML and Harmony
  harmonydll_url="https://github.com/resonite-modding-group/ResoniteModLoader/releases/download/${latest_version}/0Harmony-Net8.dll"
  rmldll_url="https://github.com/resonite-modding-group/ResoniteModLoader/releases/download/${latest_version}/ResoniteModLoader.dll"
  #Download the required DLLs
  curl -L -o "rml_libs/0Harmony-Net8.dll" "$harmonydll_url"
  curl -L -o "Libraries/ResoniteModLoader.dll" "$rmldll_url"
fi
