#!/bin/bash
# MSDN 1909 ISO
packer build \
  --only=vmware-iso \
  --var vhv_enable=true \
  --var iso_url=~/packer_cache/msdn/en_windows_server_version_1909_x64_dvd_894c6446.iso \
  windows_server_1909_docker.json
  # --var autounattend=./tmp/1909/Autounattend.xml \
