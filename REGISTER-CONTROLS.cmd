@echo off
setlocal
cd /d "%~dp0"
echo Register legacy 32-bit controls. Requires Run as administrator.
echo This changes machine-wide COM registrations. No Windows DLLs are replaced.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Tools\Register-Controls.ps1"
set "RC=%ERRORLEVEL%"
echo.
echo Diagnostic: "%~dp0Logs\Registration-Results.txt"
if not "%RC%"=="0" echo One or more registrations failed; see diagnostic.
pause
exit /b %RC%
