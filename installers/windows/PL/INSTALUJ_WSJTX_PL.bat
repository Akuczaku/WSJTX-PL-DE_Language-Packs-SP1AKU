@REM ================================================================
@REM Polskie tlumaczenie i pakiet jezykowy: SP1AKU Czaku
@REM AUTO PATH: automatyczne wykrywanie lub reczny wybor instalacji.
@REM WSJT-X pozostaje projektem jego oryginalnych autorow.
@REM ================================================================
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
title WSJT-X 3.0.2 PL - instalacja pelna - SP1AKU Czaku

net session >nul 2>&1
if not "%errorlevel%"=="0" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

set "CFGDIR=%APPDATA%\WSJTX_PL_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WYBIERZ_SCIEZKE_WSJTX.ps1"

if not exist "%HELPER%" (
  echo BLAD: Brak pliku WYBIERZ_SCIEZKE_WSJTX.ps1.
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "instalacja pelna"
if errorlevel 1 (
  echo.
  echo Instalacja anulowana lub nie udalo sie ustalic sciezki WSJT-X.
  pause
  exit /b 2
)

set "WSJTX_ROOT="
set /p "WSJTX_ROOT="<"%PATHFILE%"
if not defined WSJTX_ROOT (
  echo BLAD: Nie odczytano sciezki instalacji WSJT-X.
  pause
  exit /b 3
)

set "EXE=%WSJTX_ROOT%\bin\wsjtx.exe"
set "BINDIR=%WSJTX_ROOT%\bin"
set "QM=%~dp0wsjtx_pl.qm"
set "DOCSRC=%~dp0wsjtx-main-3.0.2.html"
set "DOCDIR=%WSJTX_ROOT%\share\doc\wsjtx"
set "DOCDST=%DOCDIR%\wsjtx-main-3.0.2.html"
set "DOCBAK=%DOCDIR%\wsjtx-main-3.0.2_EN_BACKUP.html"
set "SHORTBACK=%APPDATA%\WSJTX_PL_SHORTCUT_BACKUP"

if not exist "%EXE%" (
  echo BLAD: Nie znaleziono: %EXE%
  pause
  exit /b 4
)
if not exist "%QM%" (
  echo BLAD: Brak wsjtx_pl.qm w paczce.
  pause
  exit /b 5
)
if not exist "%DOCSRC%" (
  echo BLAD: Brak wsjtx-main-3.0.2.html w paczce.
  pause
  exit /b 6
)
if not exist "%DOCDIR%\" (
  echo BLAD: Brak katalogu dokumentacji:
  echo %DOCDIR%
  pause
  exit /b 7
)

copy /Y "%QM%" "%BINDIR%\wsjtx_pl.qm" >nul
if errorlevel 1 (
  echo BLAD: Nie udalo sie skopiowac wsjtx_pl.qm.
  pause
  exit /b 8
)

if exist "%DOCDST%" if not exist "%DOCBAK%" (
  copy /Y "%DOCDST%" "%DOCBAK%" >nul
  if errorlevel 1 (
    echo BLAD: Nie udalo sie zrobic kopii podrecznika EN.
    pause
    exit /b 9
  )
)
copy /Y "%DOCSRC%" "%DOCDST%" >nul
if errorlevel 1 (
  echo BLAD: Nie udalo sie zainstalowac polskiego podrecznika.
  pause
  exit /b 10
)

set "WSJTX_EXE=%EXE%"
set "WSJTX_DIR=%BINDIR%"
set "WSJTX_BACKUP=%SHORTBACK%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$userDesk=[Environment]::GetFolderPath('Desktop'); $publicDesk=[Environment]::GetFolderPath('CommonDesktopDirectory');" ^
 "$backup=$env:WSJTX_BACKUP; New-Item -ItemType Directory -Force -Path $backup | Out-Null;" ^
 "$shell=New-Object -ComObject WScript.Shell; $exe=[IO.Path]::GetFullPath($env:WSJTX_EXE);" ^
 "$orig=$null; foreach($desk in @($userDesk,$publicDesk)){ if(-not $desk){continue}; foreach($f in Get-ChildItem -LiteralPath $desk -Filter '*.lnk' -ErrorAction SilentlyContinue){ try{$s=$shell.CreateShortcut($f.FullName); if($s.TargetPath -and ([IO.Path]::GetFullPath($s.TargetPath) -ieq $exe) -and ($s.Arguments -notmatch '(?i)--language\s*=\s*pl|--language\s+pl')){$orig=$f; break}}catch{}}; if($orig){break}};" ^
 "if($orig){Copy-Item -LiteralPath $orig.FullName -Destination (Join-Path $backup 'original.lnk') -Force; Set-Content -LiteralPath (Join-Path $backup 'original_path.txt') -Value $orig.FullName -Encoding UTF8};" ^
 "$pl=Join-Path $publicDesk 'WSJT-X 3.0.2 PL.lnk'; $s=$shell.CreateShortcut($pl); $s.TargetPath=$env:WSJTX_EXE; $s.Arguments='--language=pl'; $s.WorkingDirectory=$env:WSJTX_DIR; $s.IconLocation=$env:WSJTX_EXE+',0'; $s.Description='WSJT-X 3.0.2 - polski interfejs - SP1AKU Czaku'; $s.Save();" ^
 "if(-not (Test-Path -LiteralPath $pl)){throw 'Shortcut creation failed'}; Write-Host ('Utworzono skrot: '+$pl)"
if errorlevel 1 (
  echo BLAD: Nie udalo sie utworzyc skrotu PL.
  pause
  exit /b 11
)

echo.
echo ===============================================================
echo  GOTOWE - WSJT-X 3.0.2 PL - SP1AKU Czaku
echo  Instalacja WSJT-X: %WSJTX_ROOT%
echo.
echo  1. Zainstalowano wsjtx_pl.qm
echo  2. Zainstalowano polski podrecznik:
echo     %DOCDST%
echo  3. Utworzono skrot WSJT-X 3.0.2 PL
echo  4. Zapamietano sciezke instalacji do pozniejszego usuwania
echo  5. Oryginalny podrecznik EN zachowano jako:
echo     %DOCBAK%
echo ===============================================================
echo.
pause
endlocal
