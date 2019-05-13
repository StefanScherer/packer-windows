FROM mcr.microsoft.com/windows:ltsc2019 AS makeiso
WORKDIR C:/source
COPY . .
RUN powershell -NoProfile -ExecutionPolicy unrestricted -file make_unattend_iso.ps1

FROM mcr.microsoft.com/windowsservercore:ltsc2019
ENV chocolateyUseWindowsCompression false

RUN powershell -NoProfile -ExecutionPolicy unrestricted -Command \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress
RUN choco install -y packer
RUN powershell -Command Install-WindowsFeature Hyper-V-PowerShell
COPY --from=makeiso C:/source C:/source
WORKDIR C:/source
RUN powershell -File test.ps1
