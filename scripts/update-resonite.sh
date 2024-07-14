#!/bin/sh

/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update 2519830 -beta ${STEAM_BRANCH} -betapassword ${BETA_CODE} +quit

# Fix for issue with NVR.json migrations exploding
ln -sf /home/container/Migrations /home/container/Headless/Migrations

#Mod installation if ENABLE_MODS is true. Heavily inspired and pulled from work by Spex. Thank you
if [${ENABLE_MODS} = true]; then
  cd /home/container/Headless/net8.0
  mkdir rml_libs rml_mods rml_config Libraries
  #Copy Mods and associated files from RML volume
  cp -a /RML/rml_mods/. rml_mods/
  cp -a /RML/rml_libs/. rml_libs/
  cp -a /RML/rml_config/. rml/config/
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
