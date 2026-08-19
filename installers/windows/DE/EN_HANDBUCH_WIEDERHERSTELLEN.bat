@REM Deutsche Uebersetzung und Sprachpaket: SP1AKU Czaku
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
net session >nul 2>&1
if not "%errorlevel%"=="0" (powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs" & exit /b)
set "CFGDIR=%APPDATA%\WSJTX_DE_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WSJTX_PFAD_WAEHLEN.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "englisches Handbuch wiederherstellen"
if errorlevel 1 (exit /b 1)
set "WSJTX_ROOT="&set /p "WSJTX_ROOT="<"%PATHFILE%"
set "DOCDIR=%WSJTX_ROOT%\share\doc\wsjtx"
set "DST=%DOCDIR%\wsjtx-main-3.0.2.html"
set "BAK=%DOCDIR%\wsjtx-main-3.0.2_EN_BACKUP.html"
if not exist "%BAK%" (echo Keine Sicherung des englischen Handbuchs gefunden.&pause&exit /b 2)
copy /Y "%BAK%" "%DST%" >nul || (echo Wiederherstellung fehlgeschlagen.&pause&exit /b 3)
echo Englisches Originalhandbuch wiederhergestellt.
pause
endlocal
