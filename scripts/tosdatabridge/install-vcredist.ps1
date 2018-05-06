$vcredist_x64_url = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"
$vcredist_x86_url = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"

# Create temp dir
if ($env:TEMP -eq $null) {
  $env:TEMP = Join-Path $env:SystemDrive 'temp'
}

$vcredist_file = Join-Path $env:TEMP "vcredist.exe"

$psArchitecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

$url = ''
if ($psArchitecture -eq "64-bit") {
  $url = $vcredist_x64_url
} elseif ($psArchitecture -eq "32-bit") {
  $url = $vcredist_x86_url
}

# Download VC++ Redistribute Package
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  # use TLS 1.2
Write-Host "Downloading VC++ Redistribute from $url ..."
wget -outfile $vcredist_file $url

# Installing Visual C++ Redistributable Package
Write-Host "Installing Visual C++ Redistributable Package ..."
$vcredist_params = "/passive /norestart"
$vcredist_install_command = "$vcredist_file $vcredist_params" 
Invoke-Expression $vcredist_install_command

# Clean up
#Remove-Item -Force $vcredist_file