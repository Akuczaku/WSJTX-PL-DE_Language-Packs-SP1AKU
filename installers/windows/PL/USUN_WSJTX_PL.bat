@REM ================================================================
@REM Polskie tlumaczenie i pakiet jezykowy: SP1AKU Czaku
@REM AUTO PATH: automatyczne wykrywanie lub reczny wybor instalacji.
@REM WSJT-X pozostaje projektem jego oryginalnych autorow.
@REM ================================================================
@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1
title WSJT-X 3.0.2 PL - usuwanie i przywracanie - SP1AKU Czaku

net session >nul 2>&1
if not "%errorlevel%"=="0" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

set "CFGDIR=%APPDATA%\WSJTX_PL_SP1AKU_Czaku"
set "PATHFILE=%CFGDIR%\install_path.txt"
set "HELPER=%~dp0WYBIERZ_SCIEZKE_WSJTX.ps1"
set "SHORTBACK=%APPDATA%\WSJTX_PL_SHORTCUT_BACKUP"

powershell -NoProfile -ExecutionPolicy Bypass -File "%HELPER%" -ConfigFile "%PATHFILE%" -Purpose "usuwanie wersji PL"
if errorlevel 1 (echo Operacja anulowana.&pause&exit /b 1)
set "WSJTX_ROOT="
set /p "WSJTX_ROOT="<"%PATHFILE%"
set "EXE=%WSJTX_ROOT%\bin\wsjtx.exe"
set "BINDIR=%WSJTX_ROOT%\bin"
set "DOCDIR=%WSJTX_ROOT%\share\doc\wsjtx"
set "DOCDST=%DOCDIR%\wsjtx-main-3.0.2.html"
set "DOCBAK=%DOCDIR%\wsjtx-main-3.0.2_EN_BACKUP.html"

if exist "%BINDIR%\wsjtx_pl.qm" del /Q "%BINDIR%\wsjtx_pl.qm" >nul 2>&1
if exist "%DOCBAK%" (
  copy /Y "%DOCBAK%" "%DOCDST%" >nul
  if not errorlevel 1 del /Q "%DOCBAK%" >nul 2>&1
)

set "WSJTX_EXE=%EXE%"
set "WSJTX_DIR=%BINDIR%"
set "WSJTX_BACKUP=%SHORTBACK%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$userDesk=[Environment]::GetFolderPath('Desktop'); $publicDesk=[Environment]::GetFolderPath('CommonDesktopDirectory');" ^
 "foreach($desk in @($userDesk,$publicDesk)){if($desk){$pl=Join-Path $desk 'WSJT-X 3.0.2 PL.lnk'; if(Test-Path -LiteralPath $pl){Remove-Item -LiteralPath $pl -Force}}};" ^
 "$backup=$env:WSJTX_BACKUP; $b=Join-Path $backup 'original.lnk'; $p=Join-Path $backup 'original_path.txt';" ^
 "if(Test-Path -LiteralPath $b){$dst=Join-Path $userDesk 'WSJT-X.lnk'; if(Test-Path -LiteralPath $p){$candidate=(Get-Content -LiteralPath $p -Raw).Trim([char]0xFEFF,[char]0x0D,[char]0x0A,' '); if($candidate){$dst=$candidate}}; $parent=Split-Path -Parent $dst; if(-not (Test-Path -LiteralPath $parent)){$dst=Join-Path $userDesk (Split-Path -Leaf $dst)}; Copy-Item -LiteralPath $b -Destination $dst -Force; Write-Host ('Przywrocono skrot: '+$dst)} elseif(Test-Path -LiteralPath $env:WSJTX_EXE){$shell=New-Object -ComObject WScript.Shell; $dst=Join-Path $publicDesk 'WSJT-X.lnk'; $s=$shell.CreateShortcut($dst); $s.TargetPath=$env:WSJTX_EXE; $s.Arguments=''; $s.WorkingDirectory=$env:WSJTX_DIR; $s.IconLocation=$env:WSJTX_EXE+',0'; $s.Save(); Write-Host ('Utworzono zwykly skrot: '+$dst)};" ^
 "if(Test-Path -LiteralPath $backup){Remove-Item -LiteralPath $backup -Recurse -Force -ErrorAction SilentlyContinue}"

echo.
echo ===============================================================
echo  USUNIETO WERSJE PL - SP1AKU Czaku
echo  Instalacja WSJT-X: %WSJTX_ROOT%
echo  - usunieto wsjtx_pl.qm
echo  - usunieto skrot WSJT-X 3.0.2 PL
echo  - przywrocono zwykly skrot WSJT-X
echo  - przywrocono podrecznik EN, jezeli istniala kopia
echo ===============================================================
echo.
pause
endlocal
