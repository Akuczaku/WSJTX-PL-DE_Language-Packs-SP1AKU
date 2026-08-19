# ==================================================================
# Deutsche Uebersetzung und Sprachpaket: SP1AKU Czaku
# Automatische Erkennung einer WSJT-X-Installation.
# WSJT-X bleibt das Projekt seiner urspruenglichen Autoren.
# ==================================================================
param(
    [Parameter(Mandatory=$true)][string]$ConfigFile,
    [string]$Purpose = 'Vorgang'
)
$ErrorActionPreference = 'SilentlyContinue'
function Normalize-WSJTXRoot([string]$PathValue) {
    if ([string]::IsNullOrWhiteSpace($PathValue)) { return $null }
    $p=[Environment]::ExpandEnvironmentVariables($PathValue.Trim().Trim('"'))
    if ($p -match '^(.*?wsjtx\.exe)(?:,\d+)?$') { $p=$matches[1].Trim().Trim('"') }
    if (Test-Path -LiteralPath $p -PathType Leaf) {
        if ([IO.Path]::GetFileName($p) -ieq 'wsjtx.exe') {
            $bin=Split-Path -Parent $p
            if ((Split-Path -Leaf $bin) -ieq 'bin') { return (Split-Path -Parent $bin) }
            return $bin
        }
        return $null
    }
    if (Test-Path -LiteralPath $p -PathType Container) {
        $direct=Join-Path $p 'bin\wsjtx.exe'; if (Test-Path -LiteralPath $direct -PathType Leaf) { return $p }
        $inside=Join-Path $p 'wsjtx.exe'; if ((Split-Path -Leaf $p) -ieq 'bin' -and (Test-Path -LiteralPath $inside -PathType Leaf)) { return (Split-Path -Parent $p) }
    }
    return $null
}
$candidates=New-Object System.Collections.Generic.List[string]
function Add-Candidate([string]$Value) { $root=Normalize-WSJTXRoot $Value; if ($root -and -not ($candidates | Where-Object {$_ -ieq $root})) {[void]$candidates.Add($root)} }
if (Test-Path -LiteralPath $ConfigFile) { try { Add-Candidate ([IO.File]::ReadAllText($ConfigFile).Trim()) } catch {} }
try { Get-Process -Name wsjtx -ErrorAction SilentlyContinue | ForEach-Object {if($_.Path){Add-Candidate $_.Path}} } catch {}
try { Get-PSDrive -PSProvider FileSystem | ForEach-Object { $r=$_.Root; @((Join-Path $r 'WSJT\wsjtx'),(Join-Path $r 'WSJT-X'),(Join-Path $r 'wsjtx'),(Join-Path $r 'Program Files\WSJT-X'),(Join-Path $r 'Program Files\WSJT\wsjtx'),(Join-Path $r 'Program Files (x86)\WSJT-X')) | ForEach-Object {Add-Candidate $_} } } catch {}
try {
 $shell=New-Object -ComObject WScript.Shell
 $folders=@([Environment]::GetFolderPath('Desktop'),[Environment]::GetFolderPath('CommonDesktopDirectory'),[Environment]::GetFolderPath('Programs'),[Environment]::GetFolderPath('CommonPrograms')) | Where-Object {$_ -and (Test-Path -LiteralPath $_)} | Select-Object -Unique
 foreach($folder in $folders){ Get-ChildItem -LiteralPath $folder -Filter '*.lnk' -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {try{$sc=$shell.CreateShortcut($_.FullName); if($sc.TargetPath -and ([IO.Path]::GetFileName($sc.TargetPath) -ieq 'wsjtx.exe')){Add-Candidate $sc.TargetPath}}catch{}} }
} catch {}
try {
 foreach($rp in @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*')) {
  Get-ItemProperty $rp -ErrorAction SilentlyContinue | Where-Object {$_.DisplayName -and $_.DisplayName -like 'WSJT-X*'} | ForEach-Object {if($_.InstallLocation){Add-Candidate $_.InstallLocation}; if($_.DisplayIcon){Add-Candidate $_.DisplayIcon}}
 }
} catch {}
Write-Host ''; Write-Host '==============================================================='; Write-Host (' WSJT-X DE - '+$Purpose+' - Installationserkennung'); Write-Host ' Sprachpaket: SP1AKU Czaku'; Write-Host '==============================================================='
$chosen=$null
if($candidates.Count -gt 0){
 Write-Host ''; Write-Host 'Gefundene WSJT-X-Installationen:'
 for($i=0;$i -lt $candidates.Count;$i++){Write-Host ('  [{0}] {1}' -f ($i+1),$candidates[$i])}
 if($candidates.Count -eq 1){$ans=Read-Host 'Diese Installation verwenden? [J/n]'; if([string]::IsNullOrWhiteSpace($ans) -or $ans -match '^[JjYy]'){$chosen=$candidates[0]}}
 else {while(-not $chosen){$ans=Read-Host ('Nummer 1-'+$candidates.Count+' waehlen oder M fuer manuelle Pfadeingabe'); if($ans -match '^[Mm]$'){break}; $n=0; if([int]::TryParse($ans,[ref]$n) -and $n -ge 1 -and $n -le $candidates.Count){$chosen=$candidates[$n-1];break}; Write-Host 'Ungueltige Auswahl.' -ForegroundColor Yellow}}
}
while(-not $chosen){
 Write-Host ''; Write-Host 'Pfad zur WSJT-X-Installation eingeben, z.B.:'; Write-Host '  D:\WSJT\wsjtx'; Write-Host '  D:\WSJT\wsjtx\bin'; Write-Host '  D:\WSJT\wsjtx\bin\wsjtx.exe';
 $manual=Read-Host 'Pfad (X = Abbrechen)'; if($manual -match '^[Xx]$'){exit 2}; $chosen=Normalize-WSJTXRoot $manual; if(-not $chosen){Write-Host 'wsjtx.exe wurde dort nicht gefunden. Bitte erneut versuchen.' -ForegroundColor Red}
}
$exe=Join-Path $chosen 'bin\wsjtx.exe'; if(-not(Test-Path -LiteralPath $exe -PathType Leaf)){Write-Host ('FEHLER: '+$exe+' wurde nicht gefunden.') -ForegroundColor Red;exit 3}
try{$cfgDir=Split-Path -Parent $ConfigFile;if($cfgDir -and -not(Test-Path -LiteralPath $cfgDir)){New-Item -ItemType Directory -Force -Path $cfgDir|Out-Null};[IO.File]::WriteAllText($ConfigFile,$chosen,(New-Object Text.UTF8Encoding($false)))}catch{Write-Host 'FEHLER: Pfad konnte nicht gespeichert werden.' -ForegroundColor Red;exit 4}
Write-Host '';Write-Host ('Ausgewaehlte Installation: '+$chosen) -ForegroundColor Green;Write-Host '';exit 0
