#!/bin/sh

echo Installing steamcmd
mkdir -p /home/container/steamcmd
curl -sSL -o /tmp/steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xf /tmp/steamcmd.tar.gz --directory /home/container/steamcmd
