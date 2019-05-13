#!/bin/bash
packer build --only=vmware-iso --var iso_url=~/packer_cache/insider/Windows10_InsiderPreview_Client_x64_en-us_18290.iso windows_10_insider.json

