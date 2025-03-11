# use docker_provider:  "ee", "ce", "master" or ""
$docker_provider = "ce"
$docker_version = "20.10.17"
if (Test-Path env:docker_provider) {
  $docker_provider = $env:docker_provider
}
if (Test-Path env:docker_version) {
  $docker_version = $env:docker_version
}

$ProgressPreference = 'SilentlyContinue'
if ($docker_provider -eq "ce") {
  $zip_url = $("https://download.docker.com/win/static/stable/x86_64/docker-{0}.zip" -f $docker_version)
}
elseif ($docker_provider -eq "master") {
  $docker_version = "master"
  $zip_url = "https://master.dockerproject.com/windows/x86_64/docker.zip"
}

if ($zip_url) {
  Set-ExecutionPolicy Bypass -scope Process
  New-Item -Type Directory -Path "$($env:ProgramFiles)\docker"
  Write-Output "Downloading docker $docker_version ..."
  Invoke-WebRequest -outfile $env:TEMP\docker.zip $zip_url
  Expand-Archive -Path $env:TEMP\docker.zip -DestinationPath $env:TEMP -Force
  Copy-Item $env:TEMP\docker\*.* $env:ProgramFiles\docker
  Remove-Item $env:TEMP\docker.zip
  Remove-Item -Recurse $env:TEMP\docker
  [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$($env:ProgramFiles)\docker", [EnvironmentVariableTarget]::Machine)
  $env:Path = $env:Path + ";$($env:ProgramFiles)\docker"
  Write-Output "Registering docker service ..."
  Start-Process -FilePath "$($env:ProgramFiles)\docker\dockerd.exe" -ArgumentList "--register-service" -NoNewWindow -Wait
}
else {
  Write-Output "Use get.mirantis.com/install.ps1 ..."
  Invoke-WebRequest https://get.mirantis.com/install.ps1 -OutFile $env:TEMP\install.ps1 -UseBasicParsing
  .\$env:TEMP\install.ps1
  Remove-Item $env:TEMP\install.ps1 -Force -ErrorAction SilentlyContinue
}

$ErrorActionPreference = 'Stop'
Write-Output "Starting docker ..."
Start-Service docker
