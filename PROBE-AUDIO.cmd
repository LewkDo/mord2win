@echo off
setlocal
if not exist "%WINDIR%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" (
  echo This audio check expects 64-bit Windows with WOW64.
  pause & exit /b 1
)
"%WINDIR%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0Tools\Probe-WinMM.ps1"
set "RC=%ERRORLEVEL%"
pause
exit /b %RC%
