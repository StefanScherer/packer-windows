$TOSDataBridge_install_dir          = "C:\TOSDataBridge"
$url = "https://github.com/dreamflash/TOSDataBridge/archive/master.zip"

# Create temp dir
if ($env:TEMP -eq $null) {
  $env:TEMP = Join-Path $env:SystemDrive 'temp'
}
$tosdatabridgeTempDir = Join-Path $env:TEMP "tosdatabridge"
if (![System.IO.Directory]::Exists($tosdatabridgeTempDir)) {[void][System.IO.Directory]::CreateDirectory($tosdatabridgeTempDir)}
$file = Join-Path $tosdatabridgeTempDir "tosdatabridge-master.zip"

# Download TOSDataBridge install package
Set-ExecutionPolicy Bypass -scope Process
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  # use TLS 1.2
Write-Host "Downloading TOSDataBridge from $url ..."
wget -outfile $file $url

# Install TOSDataBridge
if ([System.IO.File]::Exists($file)) {
  Write-Host "Extracting TOSDataBridge to $TOSDataBridge_install_dir ..."
  Expand-Archive -Path $file -DestinationPath $tosdatabridgeTempDir -Force
  Move-Item -Path $tosdatabridgeTempDir/TOSDataBridge-master -Destination $TOSDataBridge_install_dir

  $psArchitecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
  
  # Install VC++ Redistribute Package
  $vcredist_file = ''
  if ($psArchitecture -eq "64-bit") {
    $vcredist_file = Join-Path $TOSDataBridge_install_dir "vcredist_x64.exe"
  } elseif ($psArchitecture -eq "32-bit") {
    $vcredist_file = Join-Path $TOSDataBridge_install_dir "vcredist_x86.exe"
  }
  
  Write-Host "Installing Visual C++ Redistributable Package ..."
  $vcredist_params = "/passive /norestart"
  $vcredist_install_command = "$vcredist_file $vcredist_params" 
  Invoke-Expression $vcredist_install_command
  
  ## Sleep for 5 seconds
  ##Start-Sleep -s 5
     
  ## Install TOSDataBridge Service
  #$tos_file = Join-Path $TOSDataBridge_install_dir "tosdb-setup.bat"
  #$tos_params = ''
  #Write-Host "Installing TOSDataBridge Service ..."
  #if ($psArchitecture -eq "64-bit") {
  #  $tos_params = "x64 admin 1"
  #} elseif ($psArchitecture -eq "32-bit") {
  #  $tos_params = "x86 admin 1"
  #}

  #Set-Location -Path $TOSDataBridge_install_dir
  #$tos_install_command = "$tos_file $tos_params" 
  #Invoke-Expression $tos_install_command

} else {
  Write-Host "Install Fail: $file does not exist"
}

# Clean up
#Remove-Item -Recurse -Force $tosdatabridgeTempDir
Write-Host "tosdatabridge installed successfully."