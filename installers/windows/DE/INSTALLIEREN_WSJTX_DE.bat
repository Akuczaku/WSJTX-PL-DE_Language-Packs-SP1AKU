@REM ================================================================
@REM Deutsche Uebersetzung und Sprachpaket: SP1AKU Czaku
@REM AUTO PATH: automatische Erkennung oder manuelle Auswahl.
@REM WSJT-X bleibt das Projekt seiner urspruenglichen Autoren.
@REM ================================================================
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
title WSJT-X 3.0.2 DE - Installation - SP1AKU Czaku
net session >nul 2>&1
if not "%errorlevel%"=="0" (powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs" & exit /b)
set "CFGDIR=%APPDATA%\WSJTX_DE_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WSJTX_PFAD_WAEHLEN.ps1"
if not exist "%HELPER%" (echo FEHLER: WSJTX_PFAD_WAEHLEN.ps1 fehlt.&pause&exit /b 1)
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "vollstaendige Installation"
if errorlevel 1 (echo Installation abgebrochen.&pause&exit /b 2)
set "WSJTX_ROOT="
set /p "WSJTX_ROOT="<"%PATHFILE%"
set "EXE=%WSJTX_ROOT%\bin\wsjtx.exe"
set "BINDIR=%WSJTX_ROOT%\bin"
set "QM=%~dp0wsjtx_de.qm"
set "DOCSRC=%~dp0wsjtx-main-3.0.2.html"
set "DOCDIR=%WSJTX_ROOT%\share\doc\wsjtx"
set "DOCDST=%DOCDIR%\wsjtx-main-3.0.2.html"
set "DOCBAK=%DOCDIR%\wsjtx-main-3.0.2_EN_BACKUP.html"
set "SHORTBACK=%APPDATA%\WSJTX_DE_SHORTCUT_BACKUP"
if not exist "%EXE%" (echo FEHLER: %EXE% nicht gefunden.&pause&exit /b 3)
if not exist "%QM%" (echo FEHLER: wsjtx_de.qm fehlt.&pause&exit /b 4)
if not exist "%DOCSRC%" (echo FEHLER: Deutsches Handbuch fehlt.&pause&exit /b 5)
if not exist "%DOCDIR%\" (echo FEHLER: Dokumentationsordner fehlt: %DOCDIR%&pause&exit /b 6)
copy /Y "%QM%" "%BINDIR%\wsjtx_de.qm" >nul || (echo FEHLER beim Kopieren von wsjtx_de.qm.&pause&exit /b 7)
if exist "%DOCDST%" if not exist "%DOCBAK%" copy /Y "%DOCDST%" "%DOCBAK%" >nul
copy /Y "%DOCSRC%" "%DOCDST%" >nul || (echo FEHLER beim Installieren des deutschen Handbuchs.&pause&exit /b 8)
set "WSJTX_EXE=%EXE%"
set "WSJTX_DIR=%BINDIR%"
set "WSJTX_BACKUP=%SHORTBACK%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop'; $userDesk=[Environment]::GetFolderPath('Desktop'); $publicDesk=[Environment]::GetFolderPath('CommonDesktopDirectory'); $backup=$env:WSJTX_BACKUP; New-Item -ItemType Directory -Force -Path $backup|Out-Null; $shell=New-Object -ComObject WScript.Shell; $exe=[IO.Path]::GetFullPath($env:WSJTX_EXE); $orig=$null; foreach($desk in @($userDesk,$publicDesk)){if(-not $desk){continue};foreach($f in Get-ChildItem -LiteralPath $desk -Filter '*.lnk' -ErrorAction SilentlyContinue){try{$s=$shell.CreateShortcut($f.FullName);if($s.TargetPath -and ([IO.Path]::GetFullPath($s.TargetPath) -ieq $exe) -and ($s.Arguments -notmatch '(?i)--language\s*=\s*de|--language\s+de')){$orig=$f;break}}catch{}};if($orig){break}}; if($orig){Copy-Item -LiteralPath $orig.FullName -Destination (Join-Path $backup 'original.lnk') -Force;Set-Content -LiteralPath (Join-Path $backup 'original_path.txt') -Value $orig.FullName -Encoding UTF8}; $lnk=Join-Path $publicDesk 'WSJT-X 3.0.2 DE.lnk'; $s=$shell.CreateShortcut($lnk);$s.TargetPath=$env:WSJTX_EXE;$s.Arguments='--language=de';$s.WorkingDirectory=$env:WSJTX_DIR;$s.IconLocation=$env:WSJTX_EXE+',0';$s.Description='WSJT-X 3.0.2 - Deutsche Oberflaeche - SP1AKU Czaku';$s.Save(); if(-not(Test-Path -LiteralPath $lnk)){throw 'Shortcut creation failed'};Write-Host ('Verknuepfung erstellt: '+$lnk)"
if errorlevel 1 (echo FEHLER: Desktop-Verknuepfung konnte nicht erstellt werden.&pause&exit /b 9)
echo.
echo ===============================================================
echo  FERTIG - WSJT-X 3.0.2 DE - SP1AKU Czaku
echo  WSJT-X: %WSJTX_ROOT%
echo  - wsjtx_de.qm installiert
echo  - deutsches Handbuch installiert
echo  - Verknuepfung "WSJT-X 3.0.2 DE" erstellt
echo  - englisches Originalhandbuch gesichert
echo ===============================================================
echo.
pause
endlocal
