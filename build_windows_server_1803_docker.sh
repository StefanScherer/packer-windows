#!/bin/bash
# MSDN 1803 ISO
packer build \
  --only=vmware-iso \
  --var vhv_enable=true \
  --var iso_url=~/packer_cache/msdn/en_windows_server_version_1803_x64_dvd_12063476.iso \
  --var autounattend=./tmp/1803/Autounattend.xml \
  windows_server_1803_docker.json
