if (Test-Path ./output-hyperv-iso) {
  Remove-Item -Recurse -Force ./output-hyperv-iso
}

packer build --only=hyperv-iso `
             --var iso_url=./iso/17763.379.190312-0539.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso `
             --var iso_checksum="221F9ACBC727297A56674A0F1722B8AC7B6E840B4E1FFBDD538A9ED0DA823562" `
             windows_2019_docker.json
