:: Ensure C:\Chocolatey\bin is on the path
set /p PATH=%PATH%;C:\ProgramData\chocolatey\
echo %PATH%

:: Install all the things; for example:
choco install /y 7zip
choco install /y notepadplusplus
choco install /y boxstarter.winconfig