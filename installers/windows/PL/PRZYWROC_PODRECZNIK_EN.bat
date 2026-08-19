@REM ================================================================
@REM Polskie tlumaczenie i pakiet jezykowy: SP1AKU Czaku
@REM AUTO PATH: automatyczne wykrywanie lub reczny wybor instalacji.
@REM ================================================================
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
title WSJT-X 3.0.2 - przywracanie podrecznika EN

net session >nul 2>&1
if not "%errorlevel%"=="0" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

set "CFGDIR=%APPDATA%\WSJTX_PL_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WYBIERZ_SCIEZKE_WSJTX.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "przywracanie podrecznika EN"
if errorlevel 1 (echo Operacja anulowana.&pause&exit /b 1)
set "WSJTX_ROOT="
set /p "WSJTX_ROOT="<"%PATHFILE%"
set "DOCDIR=%WSJTX_ROOT%\share\doc\wsjtx"
set "DST=%DOCDIR%\wsjtx-main-3.0.2.html"
set "BAK=%DOCDIR%\wsjtx-main-3.0.2_EN_BACKUP.html"

if not exist "%BAK%" (echo BLAD: Brak kopii: %BAK%&pause&exit /b 2)
copy /Y "%BAK%" "%DST%" >nul
if errorlevel 1 (echo BLAD: Nie udalo sie przywrocic podrecznika EN.&pause&exit /b 3)
del /Q "%BAK%" >nul 2>&1
echo Przywrocono oryginalny podrecznik WSJT-X 3.0.2.
pause
endlocal
