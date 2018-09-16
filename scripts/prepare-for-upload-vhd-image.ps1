# https://docs.microsoft.com/de-de/azure/virtual-machines/windows/prepare-for-upload-vhd-image
netsh winhttp reset proxy
"san policy=onlineall" | Out-File -Encoding Ascii $env:TEMP\diskpart.txt
& diskpart /s $env:TEMP\diskpart.txt

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -name "RealTimeIsUniversal" 1 -Type DWord
Set-Service -Name w32time -StartupType Automatic

powercfg /setactive SCHEME_MIN

Set-Service -Name bfe -StartupType Automatic
Set-Service -Name dhcp -StartupType Automatic
Set-Service -Name dnscache -StartupType Automatic
Set-Service -Name IKEEXT -StartupType Automatic
Set-Service -Name iphlpsvc -StartupType Automatic
Set-Service -Name netlogon -StartupType Manual
Set-Service -Name netman -StartupType Manual
Set-Service -Name nsi -StartupType Automatic
Set-Service -Name termService -StartupType Manual
Set-Service -Name MpsSvc -StartupType Automatic
Set-Service -Name RemoteRegistry -StartupType Automatic

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0 -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "fDenyTSConnections" -Value 0 -Type DWord

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "PortNumber" 3389 -Type DWord

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "LanAdapter" 0 -Type DWord

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "SecurityLayer" 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fAllowSecProtocolNegotiation" 1 -Type DWord

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "KeepAliveEnable" 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "KeepAliveInterval" 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "KeepAliveTimeout" 1 -Type DWord

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "fDisableAutoReconnect" 0 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "fInheritReconnectSame" 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "fReconnectSame" 0 -Type DWord

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "MaxInstanceCount" 4294967295 -Type DWord

Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "SSLCertificateSHA1Hash"

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile' -name "EnableFirewall" -Value 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile' -name "EnableFirewall" -Value 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\Standardprofile' -name "EnableFirewall" -Value 1 -Type DWord
 
Enable-PSRemoting -force
netsh advfirewall firewall set rule dir=in name="Windows Remote Management (HTTP-In)" new enable=yes
netsh advfirewall firewall set rule dir=in name="Windows Remote Management (HTTP-In)" new enable=yes

netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes

netsh advfirewall firewall set rule dir=in name="File and Printer Sharing (Echo Request - ICMPv4-In)" new enable=yes


bcdedit /set '{bootmgr}' integrityservices enable
bcdedit /set '{default}' device partition=C:
bcdedit /set '{default}' integrityservices enable
bcdedit /set '{default}' recoveryenabled Off
bcdedit /set '{default}' osdevice partition=C:
bcdedit /set '{default}' bootstatuspolicy IgnoreAllFailures

#Enable Serial Console Feature
bcdedit /set '{bootmgr}' displaybootmenu yes
bcdedit /set '{bootmgr}' timeout 10
bcdedit /set '{bootmgr}' bootems yes
bcdedit /ems '{current}' ON
bcdedit /emssettings EMSPORT:1 EMSBAUDRATE:115200

#Setup the Guest OS to collect a kernel dump on an OS crash event
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DumpFile /t REG_EXPAND_SZ /d "%SystemRoot%\MEMORY.DMP" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 2 /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v NMICrashDump /t REG_DWORD /d 1 /f

#Setup the Guest OS to collect user mode dumps on a service crash event
mkdir c:\Crashdumps
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v DumpFolder /t REG_EXPAND_SZ /d "c:\CrashDumps" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v CrashCount /t REG_DWORD /d 10 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v DumpType /t REG_DWORD /d 2 /f
sc config WerSvc start= demand

winmgmt /verifyrepository
