@echo off

REM Kill all running thinkorswim instances
echo Stop previous ThinkOrSwim program
TASKKILL /F /IM "thinkorswim.exe" /T
SET "ThinkOrSwim="
SET "ThinkOrSwim_Session="

REM Start ThinkOrSwim application
START "" "C:\thinkorswim\thinkorswim.exe"

TIMEOUT /T 5 /NOBREAK

::for /f "tokens=1,4 delims= " %i in ('tasklist /FI "IMAGENAME eq thinkorswim.exe" /NH') do @echo %i %j %k
FOR /F "tokens=1,4 delims= " %%G IN ('TASKLIST /FI "IMAGENAME eq thinkorswim.exe" /NH') DO (
    ::echo %%~nG
    SET "ThinkOrSwim=%%~nG"
    ::echo %%H 
    SET /A "ThinkOrSwim_Session=%%H"
)

::echo %ThinkOrSwim%

IF NOT EXIST %ThinkOrSwim% GOTO END

echo.
echo Running %ThinkOrSwim% with Session ID: %ThinkOrSwim_Session%

echo.
echo Detecting OS processor type
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto 64BIT
echo 32-bit OS
SET Processor_Arch=x86
GOTO PROCESSOR_END    
:64BIT
echo 64-bit OS
SET Processor_Arch=x64
:PROCESSOR_END

echo Go to C:\TOSDatabridge directory
CD C:\TOSDataBridge
echo .\tosdb-setup.bat %Processor_Arch% admin %ThinkOrSwim_Session%
echo.
CALL .\tosdb-setup.bat %Processor_Arch% admin %ThinkOrSwim_Session%

REM Start TOS data bridge Service
echo.
echo Start TOSDataBridge service
SC start TOSDataBridge

REM Check TOSDataBridge is running state 
TIMEOUT /T 30 /NOBREAK
FOR /F "tokens=4 delims= " %%X IN ('SC query TOSDataBridge ^| FIND /I "running"') DO SET TOSDataBridge_State=%%X
echo.
echo TOSDataBridge_State=%TOSDataBridge_State%

REM Verify TOSDataBridge is working
IF /I "%TOSDataBridge_State%"=="running" (
    echo.
    echo Validate TOSDataBridge Service
    CD C:\TOSDataBridge\test\java
    CALL .\CompileAndRun.bat
)

:END
