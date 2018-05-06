$thinkorswim_install_dir          = "C:\thinkorswim"
$url = "http://mediaserver.thinkorswim.com/installer/InstFiles/thinkorswim_x64_installer.exe"

# Create temp dir
if ($env:TEMP -eq $null) {
  $env:TEMP = Join-Path $env:SystemDrive 'temp'
}
$thinkorswimTempDir = Join-Path $env:TEMP "thinkorswim"
if (![System.IO.Directory]::Exists($thinkorswimTempDir)) {[void][System.IO.Directory]::CreateDirectory($thinkorswimTempDir)}
$file = Join-Path $thinkorswimTempDir "thinkorswim.exe"

# Download thinkorswim install package
Set-ExecutionPolicy Bypass -scope Process
# [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  # use TLS 1.2
Write-Host "Downloading ThinkOrSwim from $url ..."
wget -outfile $file $url

# Install thinkorswim
if ([System.IO.File]::Exists($file)) {
  Write-Host "Installing ThinkOrSwim to $thinkorswim_install_dir ..."
  $params = "-q -overwrite -dir $thinkorswim_install_dir"  
  $thinkorswim_install_command = "$file $params" 
  Invoke-Expression $thinkorswim_install_command
} else {
  Write-Host "Install Fail: $file does not exist"
}

# Clean up
#Remove-Item -Recurse -Force $thinkorswimTempDir
Write-Host "thinkorswim installed successfully."