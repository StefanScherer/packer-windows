New-Item -Path "C:\" -Name "Updates" -ItemType Directory

Write-Host "$(Get-Date -Format G): Downloading .NET Framework 4.8"
(New-Object Net.WebClient).DownloadFile("https://download.visualstudio.microsoft.com/download/pr/014120d7-d689-4305-befd-3cb711108212/0fd66638cde16859462a6243a4629a50/ndp48-x86-x64-allos-enu.exe", "C:\Updates\ndp48-x86-x64-allos-enu.exe")
 
Write-Host "$(Get-Date -Format G): Installing .NET Framework 4.8"
Start-Process -FilePath "C:\Updates\ndp48-x86-x64-allos-enu.exe" -ArgumentList "/quiet /norestart" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing .NET Framework 4.8. The VM will now reboot and continue the installation process."
