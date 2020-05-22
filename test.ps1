$ErrorActionPreference = 'Stop'

"dummy" | Out-File path-to.vmx
$env:PACKER_AZURE_AD_TENANT_ID="dummy"
$env:PACKER_AZURE_SUBSCRIPTION_ID="dummy"
$env:PACKER_AZURE_OBJECT_ID="dummy"
$env:PACKER_AZURE_APP_ID="dummy"
$env:PACKER_AZURE_CLIENT_SECRET="dummy"
$env:PACKER_AZURE_RESOURCE_GROUP="dummy"
$env:PACKER_AZURE_STORAGE_ACCOUNT="dummy"
$env:AWS_S3_BUCKET="dummy"

$files = @(Get-ChildItem *.json | Where-Object -FilterScript { $_.Name -ne "windows_7.json" })

foreach ($file in $files) {
  Write-Host "`n`nValidate $file"
  packer.exe validate -except=qemu $file
  if (-not $?)
  {
     throw "Packer validate found errors in $file!"
  }
}
