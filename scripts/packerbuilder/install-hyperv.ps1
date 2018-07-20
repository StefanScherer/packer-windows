New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "1" -Force

Write-Host "Installing Chocolatey"
iex (wget 'https://chocolatey.org/install.ps1' -UseBasicParsing)
choco feature disable --name showDownloadProgress
choco install -y git
choco install -y packer
choco install -y vagrant
choco install -y jre8

Write-Host "Installing Hyper-V"
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Install-WindowsFeature Hyper-V-Tools
Install-WindowsFeature Hyper-V-PowerShell

Write-Host "Delay WinRM start"
. sc.exe config winrm start= delayed-auto
