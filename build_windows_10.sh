#!/bin/bash
packer build --only=vmware-iso --var iso_url=~/Downloads/17763.1.180914-1434.rs5_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso windows_10.json

