#!/bin/bash

packer build \
  --only=vmware-iso \
  --var vhv_enable=true \
  --var iso_url=~/Downloads/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso  \
  windows_2025_core.json
