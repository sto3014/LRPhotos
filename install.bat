@echo off
set SCRIPT_DIR=%~dp0
set VERSION=1.3.0
::
cd /d %SCRIPT_DIR%target
powershell -command "Expand-Archive -Force 'LRPhotos%VERSION%_win.zip' '%HOMEDRIVE%%HOMEPATH%'"

