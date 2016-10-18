Write-Host "Installing WindowsServerCore container image..."
& docker pull microsoft/windowsservercore:10.0.14393.321
& docker tag microsoft/windowsservercore:10.0.14393.321 microsoft/windowsservercore:latest

Write-Host "Installing NanoServer container image..."
& docker pull microsoft/nanoserver:10.0.14393.321
& docker tag microsoft/nanoserver:10.0.14393.321 microsoft/nanoserver:latest
