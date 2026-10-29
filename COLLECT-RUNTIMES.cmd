@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Tools\Collect-Runtimes.ps1"
set "RC=%ERRORLEVEL%"
pause
exit /b %RC%
