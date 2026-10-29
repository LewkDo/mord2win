@echo off
setlocal
cd /d "%~dp0"
echo Mordor II v0.992b Windows 11 compatibility setup
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Tools\Install-Compat.ps1" %*
set "RESULT=%ERRORLEVEL%"
echo.
if not "%RESULT%"=="0" echo Setup did not finish successfully. Exit code %RESULT%.
pause
exit /b %RESULT%
