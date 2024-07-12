#!/bin/sh

rm -r /home/container/Headless/Data
rm -r /home/container/Headless/Cache

mono /home/container/Headless/Resonite.exe -HeadlessConfig /Config/${CONFIG_FILE} -Logs /Logs/ ${ADDITIONAL_ARGUMENTS}
