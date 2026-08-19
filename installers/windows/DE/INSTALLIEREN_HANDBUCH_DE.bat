@REM Deutsche Uebersetzung und Sprachpaket: SP1AKU Czaku
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
net session >nul 2>&1
if not "%errorlevel%"=="0" (powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs" & exit /b)
set "CFGDIR=%APPDATA%\WSJTX_DE_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WSJTX_PFAD_WAEHLEN.ps1"
set "SRC=%~dp0wsjtx-main-3.0.2.html"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "deutsches Handbuch installieren"
if errorlevel 1 (echo Abgebrochen.&pause&exit /b 1)
set "WSJTX_ROOT="&set /p "WSJTX_ROOT="<"%PATHFILE%"
set "DOCDIR=%WSJTX_ROOT%\share\doc\wsjtx"
set "DST=%DOCDIR%\wsjtx-main-3.0.2.html"
set "BAK=%DOCDIR%\wsjtx-main-3.0.2_EN_BACKUP.html"
if not exist "%DOCDIR%\" (echo Dokumentationsordner fehlt.&pause&exit /b 2)
if exist "%DST%" if not exist "%BAK%" copy /Y "%DST%" "%BAK%" >nul
copy /Y "%SRC%" "%DST%" >nul || (echo Kopieren fehlgeschlagen.&pause&exit /b 3)
echo Deutsches Handbuch installiert: %DST%
pause
endlocal
