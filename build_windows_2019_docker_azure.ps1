./make_unattend_iso.ps1

if (Test-Path ./output-hyperv-iso) {
  Remove-Item -Recurse -Force ./output-hyperv-iso
}
packer build --only=hyperv-iso --var iso_url=./local.iso windows_2019_docker_azure.json
