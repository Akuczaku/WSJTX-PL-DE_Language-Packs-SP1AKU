@REM Deutsche Uebersetzung und Sprachpaket: SP1AKU Czaku
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
set "CFGDIR=%APPDATA%\WSJTX_DE_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WSJTX_PFAD_WAEHLEN.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "DE-Verknuepfung erstellen"
if errorlevel 1 (exit /b 1)
set "WSJTX_ROOT="&set /p "WSJTX_ROOT="<"%PATHFILE%"
set "WSJTX_EXE=%WSJTX_ROOT%\bin\wsjtx.exe"
set "WSJTX_DIR=%WSJTX_ROOT%\bin"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$desk=[Environment]::GetFolderPath('Desktop');$shell=New-Object -ComObject WScript.Shell;$lnk=Join-Path $desk 'WSJT-X 3.0.2 DE.lnk';$s=$shell.CreateShortcut($lnk);$s.TargetPath=$env:WSJTX_EXE;$s.Arguments='--language=de';$s.WorkingDirectory=$env:WSJTX_DIR;$s.IconLocation=$env:WSJTX_EXE+',0';$s.Description='WSJT-X 3.0.2 DE - SP1AKU Czaku';$s.Save();Write-Host ('Erstellt: '+$lnk)"
pause
endlocal
