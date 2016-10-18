Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DockerMsftProvider -Force
Set-PSRepository -InstallationPolicy Trusted -Name PSGallery
Install-Package -Name docker -ProviderName DockerMsftProvider -Force
Set-PSRepository -InstallationPolicy Untrusted -Name PSGallery
