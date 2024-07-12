#!/bin/sh

/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container +app_update 2519830 -beta ${STEAM_BRANCH} -betapassword ${BETA_CODE} +quit

# Fix for issue with NVR.json migrations exploding
ln -sf /home/container/Migrations /home/container/Headless/Migrations
