#!/bin/sh

rm -r /home/container/Headless/Data
rm -r /home/container/Headless/Cache

cd /home/container/Headless/net8.0
dotnet Resonite.dll -HeadlessConfig /Config/${CONFIG_FILE} -Logs /Logs/ ${ADDITIONAL_ARGUMENTS}

#dotnet /home/container/Headless/net8.0/Resonite.dll -HeadlessConfig /Config/${CONFIG_FILE} -Logs /Logs/ ${ADDITIONAL_ARGUMENTS}
