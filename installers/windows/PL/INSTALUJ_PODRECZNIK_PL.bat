@REM ================================================================
@REM Polskie tlumaczenie i pakiet jezykowy: SP1AKU Czaku
@REM AUTO PATH: automatyczne wykrywanie lub reczny wybor instalacji.
@REM WSJT-X pozostaje projektem jego oryginalnych autorow.
@REM ================================================================
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
title WSJT-X 3.0.2 PL - instalacja podrecznika - SP1AKU Czaku

net session >nul 2>&1
if not "%errorlevel%"=="0" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

set "CFGDIR=%APPDATA%\WSJTX_PL_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WYBIERZ_SCIEZKE_WSJTX.ps1"
set "SRC=%~dp0wsjtx-main-3.0.2.html"

if not exist "%SRC%" (echo BLAD: Brak pliku wsjtx-main-3.0.2.html.&pause&exit /b 1)
if not exist "%HELPER%" (echo BLAD: Brak pomocnika wyboru sciezki.&pause&exit /b 2)

powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "instalacja podrecznika PL"
if errorlevel 1 (echo Instalacja anulowana.&pause&exit /b 3)

set "WSJTX_ROOT="
set /p "WSJTX_ROOT="<"%PATHFILE%"
set "DOCDIR=%WSJTX_ROOT%\share\doc\wsjtx"
set "DST=%DOCDIR%\wsjtx-main-3.0.2.html"
set "BAK=%DOCDIR%\wsjtx-main-3.0.2_EN_BACKUP.html"

if not exist "%DOCDIR%\" (echo BLAD: Brak katalogu %DOCDIR%&pause&exit /b 4)
if exist "%DST%" if not exist "%BAK%" copy /Y "%DST%" "%BAK%" >nul
if errorlevel 1 (echo BLAD: Nie udalo sie wykonac kopii EN.&pause&exit /b 5)
copy /Y "%SRC%" "%DST%" >nul
if errorlevel 1 (echo BLAD: Nie udalo sie skopiowac polskiego podrecznika.&pause&exit /b 6)

echo.
echo GOTOWE. Polski podrecznik zainstalowano w:
echo %DST%
echo.
pause
endlocal
