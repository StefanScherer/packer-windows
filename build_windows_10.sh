#!/bin/bash

packer build --only=vmware-iso \
  --var iso_url=~/packer_cache/msdn/de_windows_10_consumer_editions_version_2004_x64_dvd_7efdffc7.iso \
  --var iso_checksum=908bca712c7f5ec5655882237aa447dde446e9a5e5178e2202ebae0157fd0d29 \
  --var autounattend=tmp/10_pro_de/Autounattend.xml \
  windows_10_insider.json

