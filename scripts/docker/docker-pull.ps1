$images = ""
if (Test-Path env:docker_images) {
  $images = $env:docker_images.split()
}

function DockerPull {
  Param ([string]$image)

  if ($image -eq "") {
    return
  }

  Write-Output "Installing $image ..."
  $j = Start-Job -ScriptBlock { docker pull $args[0] } -ArgumentList "$image"
  while ( $j.JobStateInfo.state -ne "Completed" -And $j.JobStateInfo.state -ne "Failed" ) {
    Write-Output $j.JobStateInfo.state
    Start-Sleep 30
  }

  $results = Receive-Job -Job $j
  $results
}

function DockerRun {
  Param ([string]$image)

  if ($image -eq "") {
    return
  }

  Write-Output "Run first container from $image ..."
  docker run --rm $image cmd
}

$images | ForEach-Object {
  DockerPull $_
}
$images | ForEach-Object {
  DockerPull $_
}

$images | ForEach-Object {
  DockerRun $_
}
