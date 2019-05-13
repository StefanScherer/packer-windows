
Write-Output 'Do not open Server Manager at logon'
New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "1" -Force

Write-Output 'Install bginfo'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (!(Test-Path 'c:\Program Files\sysinternals')) {
  New-Item -Path 'c:\Program Files\sysinternals' -type directory -Force -ErrorAction SilentlyContinue
}
if (!(Test-Path 'c:\Program Files\sysinternals\bginfo.exe')) {
  (New-Object Net.WebClient).DownloadFile('https://live.sysinternals.com/bginfo.exe', 'c:\Program Files\sysinternals\bginfo.exe')
}
if (!(Test-Path 'c:\Program Files\sysinternals\bginfo.bgi')) {
  (New-Object Net.WebClient).DownloadFile('https://github.com/StefanScherer/windows-docker-workshop/raw/master/prepare-vms/azure/packer/bginfo.bgi', 'c:\Program Files\sysinternals\bginfo.bgi')
}
if (!(Test-Path 'c:\Program Files\sysinternals\background.jpg')) {
  (New-Object Net.WebClient).DownloadFile('https://github.com/StefanScherer/windows-docker-workshop/raw/master/prepare-vms/azure/packer/background.jpg', 'c:\Program Files\sysinternals\background.jpg')
}
$vbsScript = @'
WScript.Sleep 2000
Dim objShell
Set objShell = WScript.CreateObject( "WScript.Shell" )
objShell.Run("""c:\Program Files\sysinternals\bginfo.exe"" /accepteula ""c:\Program Files\sysinternals\bginfo.bgi"" /silent /timer:0")
'@
$vbsScript | Out-File 'c:\Program Files\sysinternals\bginfo.vbs'
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name bginfo -Value 'wscript "c:\Program Files\sysinternals\bginfo.vbs"'
wscript "c:\Program Files\sysinternals\bginfo.vbs"

Write-Output 'Install Chocolatey'
Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression

Write-Output 'Install editors'
choco install -y visualstudiocode

Write-Output 'Install Git'
choco install -y git

Write-Output 'Install browsers'
choco install -y googlechrome
choco install -y firefox

Write-Output 'Install Docker Compose'
choco install -y docker-compose
