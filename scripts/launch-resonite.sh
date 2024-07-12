#!/bin/sh

rm -r /home/container/Headless/Data
rm -r /home/container/Headless/Cache

dotnet /home/container/Headless/net8.0/Resonite.dll -HeadlessConfig /Config/${CONFIG_FILE} -Logs /Logs/ ${ADDITIONAL_ARGUMENTS}
