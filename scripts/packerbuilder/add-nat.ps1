Write-Host "Enable WinRM start"
. sc.exe config winrm start= auto

Write-Host "Installing Vagrant plugins"
vagrant plugin install vagrant-reload

Write-Host "Adding NAT"
New-VMSwitch -SwitchName "packer-hyperv-iso" -SwitchType Internal
New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex (Get-NetAdapter -name "vEthernet (packer-hyperv-iso)").ifIndex
New-NetNat -Name MyNATnetwork -InternalIPInterfaceAddressPrefix 192.168.0.0/24

Write-Host "Adding DHCP scope"
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerv4Scope -Name "Internal" -StartRange 192.168.0.10 -EndRange 192.168.0.250 -SubnetMask 255.255.255.0 -Description "Internal Network"
Set-DhcpServerv4OptionValue -ScopeID 192.168.0 -DNSServer 8.8.8.8 -Router 192.168.0.1

Write-Host "Allow Packer http server"
New-NetFirewallRule -DisplayName "Allow Packer" -Direction Inbound -Program "C:\ProgramData\chocolatey\lib\packer\tools\packer.exe" -RemoteAddress LocalSubnet -Action Allow
