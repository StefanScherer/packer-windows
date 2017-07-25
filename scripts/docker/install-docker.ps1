Get-PackageSource
Write-Host "Install-PackageProvider ..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Get-PackageSource
Write-Host "Install-Module ..."
Install-Module -Name DockerMsftProvider -Force
Get-PackageSource
Write-Host "Set-PSRepository trusted ..."
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery
Write-Host "Install-Package ..."
Install-Package -Name docker -ProviderName DockerMsftProvider -Force
Write-Host "Set-PSRepository untrusted ..."
Set-PSRepository -InstallationPolicy Untrusted -Name PSGallery
Write-Host "Fix --restart=always for reboot ..."
# see https://github.com/docker/docker/issues/27544
& sc config Docker depend=LanmanWorkstation
