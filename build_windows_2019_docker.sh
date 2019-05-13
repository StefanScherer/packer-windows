#!/bin/bash
# Insider ISO
packer build \
  --only=vmware-iso \
  --var vhv_enable=true \
  --var autounattend=./tmp/2019_core/Autounattend.xml \
  --var iso_url=~/packer_cache/msdn/en_windows_server_2019_x64_dvd_4cb967d8.iso \
  --var iso_checksum="4C5DD63EFEE50117986A2E38D4B3A3FBAF3C1C15E2E7EA1D23EF9D8AF148DD2D" \
  windows_2019_docker.json
