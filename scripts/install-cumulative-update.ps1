$ErrorActionPreference = 'Stop'

$Session = New-Object -ComObject 'Microsoft.Update.Session'
$Session.ClientApplicationID = 'Packer Windows Update Installer'
$UpdateSearcher = $Session.CreateUpdateSearcher()
Write-Output "Searching for Windows updates ..."
$SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")
$Updates = $SearchResult.Updates
$UpdatesToDownload = New-Object -ComObject 'Microsoft.Update.UpdateColl'

if ($Updates.Count -gt 0) {
  $i = $Updates.Count - 1
  while ($i -ge 0) {
    $Update = $Updates.Item($i)
    if ($Update.Title -match "Cumulative Update") {
      Write-Output "Found $($Update.Title)"
      if (!($Update.EulaAccepted)) {
        $Update.AcceptEula()
      }
      $UpdatesToDownload.Add($Update) | Out-Null
      break
    }
    $i--
  }
}

if ($UpdatesToDownload.Count -eq 0) {
  Write-Output "No cumulative Windows updates found."
} else {
  Write-Output "Downloading cumulative Windows update ..."
  $Downloader = $Session.CreateUpdateDownloader()
  $Downloader.Updates = $UpdatesToDownload
  $Downloader.Download()

  Write-Output "Installing Windows update ..."
  $Installer = $Session.CreateUpdateInstaller()
  $Installer.Updates = $UpdatesToDownload
  $InstallationResult = $Installer.Install()

  Write-Output "Installation Result: $($InstallationResult.ResultCode)"
  Write-Output "Reboot Required: $($InstallationResult.RebootRequired)"
}
