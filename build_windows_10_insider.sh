#!/bin/bash
packer build --only=vmware-iso \
  --var iso_url=~/packer_cache/insider/Windows10_InsiderPreview_Client_x64_en-us_19041.iso \
  --var iso_checksum=49103c4311c63c41690b0bb445e3d3adc7904a0c29ad031169d18d4d85b66478 \
  --var autounattend=tmp/10_pro/Autounattend.xml \
  windows_10_insider.json

# packer build --only=vmware-iso \
#   --var iso_url=~/packer_cache/insider/uupdump_19041.1_PROFESSIONAL_X64_EN-US.iso \
#   --var iso_checksum=bcf500c09e2048c8bd2b710ba2b75bed9fe6ef07ea2a584599af81b4b8baa5ed \
#   --var autounattend=tmp/10_pro/Autounattend.xml \
#   windows_10_insider.json
