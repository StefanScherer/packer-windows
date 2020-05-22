# First check if Service Pack 1 is installed.
$os = Get-WmiObject -class Win32_OperatingSystem
if ($os.ServicePackMajorVersion -ge 1) {
    Write-Host "Windows 7 Service Pack 1 is already installed."
    Exit
}

New-Item -Path "C:\" -Name "Updates" -ItemType Directory

# Service Pack 1 is an absolute requirement. Installing updates from Windows Update
# will fail if SP1 is not installed.
Write-Host "$(Get-Date -Format G): Downloading and installing Windows 7 Service Pack 1."
Write-Host "$(Get-Date -Format G): This process can take up to 30 minutes."

Write-Host "$(Get-Date -Format G): Downloading Windows 7 Service Pack 1"
(New-Object Net.WebClient).DownloadFile("https://download.microsoft.com/download/0/A/F/0AFB5316-3062-494A-AB78-7FB0D4461357/windows6.1-KB976932-X64.exe", "C:\Updates\windows6.1-KB976932-X64.exe")

Write-Host "$(Get-Date -Format G): Installing Windows 7 Service Pack 1"
Start-Process -FilePath "C:\Updates\Windows6.1-KB976932-X64.exe" -ArgumentList "/unattend /nodialog /norestart" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse

Write-Host "$(Get-Date -Format G): Finished installing Windows 7 Service Pack 1. The VM will now reboot and continue the installation process."
Write-Host "$(Get-Date -Format G): This may take a couple of minutes."
