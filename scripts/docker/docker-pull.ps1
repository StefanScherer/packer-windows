$images = ""
if (Test-Path env:docker_images) {
  $images = $env:docker_images.split() 
}

function DockerPull {
  Param ([string]$image)

  if ($image -eq "") {
    return
  }

  Write-Host Installing $image ...
  $j = Start-Job -ScriptBlock { docker pull $args[0] } -ArgumentList "$image"
  while ( $j.JobStateInfo.state -ne "Completed" -And $j.JobStateInfo.state -ne "Failed" ) {
    Write-Host $j.JobStateInfo.state
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

  Write-Host Run first container from $image ...
  docker run --rm $image cmd
}

$images | foreach {
  DockerPull $_
}
$images | foreach {
  DockerPull $_
}

$images | foreach {
  DockerRun $_
}
