@echo off
setlocal
cd /d "%~dp0" || (echo Could not open game directory & pause & exit /b 1)
if not exist "Data\M2ObjectsI.MDR" (echo Missing Data\M2ObjectsI.MDR & pause & exit /b 1)
if not exist "opengl.dll" (echo Compatibility opengl.dll not installed & pause & exit /b 1)
set "PATH=%CD%;%CD%\Legacy;%PATH%"
echo Start with your sound output/headphones connected and powered on.
start "" /D "%CD%" "%CD%\Mordor II.exe"
