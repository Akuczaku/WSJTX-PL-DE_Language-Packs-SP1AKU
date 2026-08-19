# ==================================================================
# Polskie tlumaczenie i pakiet jezykowy: SP1AKU Czaku
# Pomocnik wykrywania niestandardowej instalacji WSJT-X.
# WSJT-X pozostaje projektem jego oryginalnych autorow.
# ==================================================================
param(
    [Parameter(Mandatory=$true)]
    [string]$ConfigFile,
    [string]$Purpose = 'operacja'
)

$ErrorActionPreference = 'SilentlyContinue'

function Normalize-WSJTXRoot([string]$PathValue) {
    if ([string]::IsNullOrWhiteSpace($PathValue)) { return $null }
    $p = [Environment]::ExpandEnvironmentVariables($PathValue.Trim().Trim('"'))
    # DisplayIcon z rejestru moze miec format "...\\wsjtx.exe",0
    if ($p -match '^(.*?wsjtx\.exe)(?:,\d+)?$') { $p = $matches[1].Trim().Trim('"') }

    if (Test-Path -LiteralPath $p -PathType Leaf) {
        if ([IO.Path]::GetFileName($p) -ieq 'wsjtx.exe') {
            $bin = Split-Path -Parent $p
            if ((Split-Path -Leaf $bin) -ieq 'bin') {
                return (Split-Path -Parent $bin)
            }
            return $bin
        }
        return $null
    }

    if (Test-Path -LiteralPath $p -PathType Container) {
        $direct = Join-Path $p 'bin\wsjtx.exe'
        if (Test-Path -LiteralPath $direct -PathType Leaf) { return $p }

        $inside = Join-Path $p 'wsjtx.exe'
        if ((Split-Path -Leaf $p) -ieq 'bin' -and (Test-Path -LiteralPath $inside -PathType Leaf)) {
            return (Split-Path -Parent $p)
        }
    }
    return $null
}

$candidates = New-Object System.Collections.Generic.List[string]
function Add-Candidate([string]$Value) {
    $root = Normalize-WSJTXRoot $Value
    if ($root -and -not ($candidates | Where-Object { $_ -ieq $root })) {
        [void]$candidates.Add($root)
    }
}

# 1. Sciezka zapamietana przez poprzednie uruchomienie paczki SP1AKU Czaku.
if (Test-Path -LiteralPath $ConfigFile) {
    try { Add-Candidate ([IO.File]::ReadAllText($ConfigFile).Trim()) } catch {}
}

# 2. Jezeli WSJT-X jest uruchomiony, jego sciezka jest najlepszym tropem.
try {
    Get-Process -Name wsjtx -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Path) { Add-Candidate $_.Path }
    }
} catch {}

# 3. Typowe lokalizacje na wszystkich dostepnych dyskach: C:, D:, E: itd.
try {
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        $root = $_.Root
        @(
            (Join-Path $root 'WSJT\wsjtx'),
            (Join-Path $root 'WSJT-X'),
            (Join-Path $root 'wsjtx'),
            (Join-Path $root 'Program Files\WSJT-X'),
            (Join-Path $root 'Program Files\WSJT\wsjtx'),
            (Join-Path $root 'Program Files (x86)\WSJT-X')
        ) | ForEach-Object { Add-Candidate $_ }
    }
} catch {}

# 4. Skroty na pulpicie i w menu Start - pozwalaja znalezc nawet bardzo nietypowa lokalizacje.
try {
    $shell = New-Object -ComObject WScript.Shell
    $shortcutFolders = @(
        [Environment]::GetFolderPath('Desktop'),
        [Environment]::GetFolderPath('CommonDesktopDirectory'),
        [Environment]::GetFolderPath('Programs'),
        [Environment]::GetFolderPath('CommonPrograms')
    ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -Unique

    foreach ($folder in $shortcutFolders) {
        Get-ChildItem -LiteralPath $folder -Filter '*.lnk' -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $sc = $shell.CreateShortcut($_.FullName)
                if ($sc.TargetPath -and ([IO.Path]::GetFileName($sc.TargetPath) -ieq 'wsjtx.exe')) {
                    Add-Candidate $sc.TargetPath
                }
            } catch {}
        }
    }
} catch {}

# 5. Informacje instalatora zapisane w rejestrze Windows.
try {
    $regPaths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    foreach ($rp in $regPaths) {
        Get-ItemProperty $rp -ErrorAction SilentlyContinue | Where-Object {
            $_.DisplayName -and $_.DisplayName -like 'WSJT-X*'
        } | ForEach-Object {
            if ($_.InstallLocation) { Add-Candidate $_.InstallLocation }
            if ($_.DisplayIcon) { Add-Candidate $_.DisplayIcon }
        }
    }
} catch {}

Write-Host ''
Write-Host '==============================================================='
Write-Host (' WSJT-X PL - ' + $Purpose + ' - wykrywanie instalacji')
Write-Host ' Pakiet jezykowy: SP1AKU Czaku'
Write-Host '==============================================================='

$chosen = $null
if ($candidates.Count -gt 0) {
    Write-Host ''
    Write-Host 'Wykryte instalacje WSJT-X:'
    for ($i = 0; $i -lt $candidates.Count; $i++) {
        Write-Host ('  [{0}] {1}' -f ($i + 1), $candidates[$i])
    }

    if ($candidates.Count -eq 1) {
        $ans = Read-Host 'Czy uzyc tej instalacji? [T/n]'
        if ([string]::IsNullOrWhiteSpace($ans) -or $ans -match '^[TtYy]') {
            $chosen = $candidates[0]
        }
    } else {
        while (-not $chosen) {
            $ans = Read-Host ('Wybierz numer 1-' + $candidates.Count + ' albo wpisz R aby podac sciezke recznie')
            if ($ans -match '^[Rr]$') { break }
            $n = 0
            if ([int]::TryParse($ans, [ref]$n) -and $n -ge 1 -and $n -le $candidates.Count) {
                $chosen = $candidates[$n - 1]
                break
            }
            Write-Host 'Nieprawidlowy wybor.' -ForegroundColor Yellow
        }
    }
}

while (-not $chosen) {
    Write-Host ''
    Write-Host 'Podaj sciezke do instalacji WSJT-X.'
    Write-Host 'Mozesz podac jeden z ponizszych wariantow:'
    Write-Host '  D:\WSJT\wsjtx'
    Write-Host '  D:\WSJT\wsjtx\bin'
    Write-Host '  D:\WSJT\wsjtx\bin\wsjtx.exe'
    Write-Host ''
    $manual = Read-Host 'Sciezka (X = anuluj)'
    if ($manual -match '^[Xx]$') { exit 2 }
    $chosen = Normalize-WSJTXRoot $manual
    if (-not $chosen) {
        Write-Host 'Nie znaleziono wsjtx.exe pod podana sciezka. Sprobuj ponownie.' -ForegroundColor Red
    }
}

$exe = Join-Path $chosen 'bin\wsjtx.exe'
if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) {
    Write-Host ('BLAD: Nie znaleziono ' + $exe) -ForegroundColor Red
    exit 3
}

try {
    $cfgDir = Split-Path -Parent $ConfigFile
    if ($cfgDir -and -not (Test-Path -LiteralPath $cfgDir)) {
        New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
    }
    [IO.File]::WriteAllText($ConfigFile, $chosen, (New-Object Text.UTF8Encoding($false)))
} catch {
    Write-Host 'BLAD: Nie mozna zapisac wybranej sciezki.' -ForegroundColor Red
    exit 4
}

Write-Host ''
Write-Host ('Wybrana instalacja: ' + $chosen) -ForegroundColor Green
Write-Host ''
exit 0
