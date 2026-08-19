@REM ================================================================
@REM Polskie tlumaczenie i pakiet jezykowy: SP1AKU Czaku
@REM AUTO PATH: automatyczne wykrywanie lub reczny wybor instalacji.
@REM ================================================================
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
set "CFGDIR=%APPDATA%\WSJTX_PL_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WYBIERZ_SCIEZKE_WSJTX.ps1"

powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "tworzenie skrotu PL"
if errorlevel 1 (echo Operacja anulowana.&pause&exit /b 1)
set "WSJTX_ROOT="
set /p "WSJTX_ROOT="<"%PATHFILE%"
set "WSJTX_EXE=%WSJTX_ROOT%\bin\wsjtx.exe"
set "WSJTX_DIR=%WSJTX_ROOT%\bin"
if not exist "%WSJTX_EXE%" (echo BLAD: Brak %WSJTX_EXE%&pause&exit /b 2)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=[Environment]::GetFolderPath('CommonDesktopDirectory');$w=New-Object -ComObject WScript.Shell;$p=Join-Path $d 'WSJT-X 3.0.2 PL.lnk';$s=$w.CreateShortcut($p);$s.TargetPath=$env:WSJTX_EXE;$s.Arguments='--language=pl';$s.WorkingDirectory=$env:WSJTX_DIR;$s.IconLocation=$env:WSJTX_EXE+',0';$s.Description='WSJT-X 3.0.2 PL - SP1AKU Czaku';$s.Save();Write-Host ('Utworzono: '+$p)"
if errorlevel 1 (echo BLAD: Nie udalo sie utworzyc skrotu.&pause&exit /b 3)
pause
endlocal
