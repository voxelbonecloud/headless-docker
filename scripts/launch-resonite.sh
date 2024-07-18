#!/bin/sh

echo FUCK!

rm -r /home/container/Headless/Data
rm -r /home/container/Headless/Cache
find /Logs -type f -name *.log -atime +${LOG_RETENTION:-30} -delete

cd /home/container/Headless/net8.0

if [ "${ENABLE_MODS}" = "true" ]; then
	exec dotnet Resonite.dll -HeadlessConfig /Config/${CONFIG_FILE} -Logs /Logs/ -LoadAssembly Libraries/ResoniteModLoader.dll ${ADDITIONAL_ARGUMENTS}
else
	exec dotnet Resonite.dll -HeadlessConfig /Config/${CONFIG_FILE} -Logs /Logs/ ${ADDITIONAL_ARGUMENTS}
fi
