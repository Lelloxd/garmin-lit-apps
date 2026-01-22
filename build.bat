@echo off
REM Build script for Golf Range app
REM Make sure you have Garmin Connect IQ SDK installed

echo Building Golf Range for Vivoactive 3...
echo.

REM Check if GARMIN_HOME is set
if not defined GARMIN_HOME (
    echo ERROR: GARMIN_HOME environment variable not set
    echo Please set GARMIN_HOME to your Garmin Connect IQ SDK installation directory
    echo Example: set GARMIN_HOME=C:\garmin\connect-iq-sdk
    pause
    exit /b 1
)

REM Create bin directory if it doesn't exist
if not exist "%~dp0bin" mkdir "%~dp0bin"

REM Compile the app
echo Compiling Monkey C code...
"%GARMIN_HOME%\bin\monkeyc" ^
    -d vivoactive3 ^
    -m "%~dp0manifest.xml" ^
    -z ^
    -o "%~dp0bin\GolfRange.prg" ^
    "%~dp0source" "%~dp0resources"

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo Build completed successfully!
echo Output: %~dp0bin\GolfRange.prg
echo.
echo Next steps:
echo 1. Install the app on your Vivoactive 3 using the Connect IQ App Store
echo    or via the Garmin Connect IQ Simulator
echo 2. Test on the device and adjust SWING_THRESHOLD if needed
echo.
pause
