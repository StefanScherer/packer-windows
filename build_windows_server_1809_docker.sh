#!/bin/bash
# MSDN 1809 ISO
packer build \
  --only=vmware-iso \
  --var vhv_enable=true \
  --var iso_url=~/packer_cache/msdn/en_windows_server_version_1809_x64_dvd_92d11ba1.iso \
  --var autounattend=./tmp/1809/Autounattend.xml \
  windows_server_1809_docker.json
