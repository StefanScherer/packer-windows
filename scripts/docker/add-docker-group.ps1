Write-Host Creating group docker
net localgroup docker /add
$username = $env:USERNAME
Write-Host Adding user $username to group docker
net localgroup docker $username /add

$env:Path = $env:Path + ";$($env:ProgramFiles)\docker"
. dockerd --unregister-service
. dockerd --register-service -H npipe:// -H 0.0.0.0:2375 -G docker
