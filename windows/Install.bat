@echo off
echo Installing Firefox Glass theme...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
echo.
echo Done. Open Firefox.
pause
