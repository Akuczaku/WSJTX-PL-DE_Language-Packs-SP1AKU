#!/usr/bin/env bash
# ============================================================================
# Deutsche Übersetzung und Sprachpaket: SP1AKU Czaku
# Linux installer for WSJT-X 3.0.2 language package.
# WSJT-X remains the project of its original authors / WSJT Development Team.
# ============================================================================
set -u

LANG_CODE="de"
PKG_QM="wsjtx_de.qm"
PKG_TS="wsjtx_de.ts"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$HOME/.local/share/wsjtx-sp1aku/$LANG_CODE"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
WRAPPER="$BIN_DIR/wsjtx-de"
DESKTOP="$APP_DIR/wsjtx-de.desktop"
MANUAL_DESKTOP="$APP_DIR/wsjtx-de-manual.desktop"
EXE_FILE="$DATA_DIR/wsjtx-executable.path"
SYSTEM_DOC_FILE="$DATA_DIR/system-doc.path"
SYSTEM_DOC_BACKUP_FILE="$DATA_DIR/system-doc-backup.path"

say() { printf '%s\n' "$*"; }
line() { say '======================================================================'; }

line
say "WSJT-X 3.0.2 DE — Linux-Installer — SP1AKU Czaku"
say "Deutsche Übersetzung und Sprachpaket: SP1AKU Czaku"
line

if [[ ! -f "$SCRIPT_DIR/$PKG_QM" ]]; then say "ERROR: $PKG_QM missing."; exit 1; fi
if [[ ! -f "$SCRIPT_DIR/wsjtx-main-3.0.2.html" ]]; then say "ERROR: wsjtx-main-3.0.2.html missing."; exit 1; fi

mkdir -p "$DATA_DIR" "$BIN_DIR" "$APP_DIR"
cp -f "$SCRIPT_DIR/$PKG_QM" "$DATA_DIR/$PKG_QM"
cp -f "$SCRIPT_DIR/wsjtx-main-3.0.2.html" "$DATA_DIR/wsjtx-main-3.0.2.html"
[[ -f "$SCRIPT_DIR/$PKG_TS" ]] && cp -f "$SCRIPT_DIR/$PKG_TS" "$DATA_DIR/$PKG_TS"

# Build a list of possible executables. The first entry is usually the distro package.
declare -a CANDIDATES=()
add_candidate() {
    local p="$1"
    [[ -z "$p" ]] && return
    if [[ -f "$p" && -x "$p" ]]; then
        local real="$p"
        command -v readlink >/dev/null 2>&1 && real="$(readlink -f "$p" 2>/dev/null || printf '%s' "$p")"
        local x
        for x in "${CANDIDATES[@]:-}"; do [[ "$x" == "$real" ]] && return; done
        CANDIDATES+=("$real")
    fi
}

if command -v wsjtx >/dev/null 2>&1; then add_candidate "$(command -v wsjtx)"; fi
[[ -f "$EXE_FILE" ]] && add_candidate "$(cat "$EXE_FILE" 2>/dev/null || true)"

# Common AppImage locations.
shopt -s nullglob
for f in "$HOME"/Downloads/*wsjtx*.AppImage "$HOME"/Downloads/*WSJT*.AppImage          "$HOME"/Applications/*wsjtx*.AppImage "$HOME"/Applications/*WSJT*.AppImage          "$HOME"/.local/bin/*wsjtx*.AppImage /opt/*wsjtx*.AppImage /opt/*WSJT*.AppImage; do
    add_candidate "$f"
done
shopt -u nullglob

WSJTX_EXE=""
if (( ${#CANDIDATES[@]} > 0 )); then
    say ""
    say "Gefundene WSJT-X-Installationen:"
    i=1
    for p in "${CANDIDATES[@]}"; do printf '  [%d] %s\n' "$i" "$p"; ((i++)); done
    if (( ${#CANDIDATES[@]} == 1 )); then
        WSJTX_EXE="${CANDIDATES[0]}"
        read -r -p "Use / użyć / verwenden? [Y/n]: " ans || true
        case "${ans:-Y}" in n|N) WSJTX_EXE="";; esac
    else
        while [[ -z "$WSJTX_EXE" ]]; do
            read -r -p "Nummer wählen oder M für manuelle Pfadeingabe: " ans
            case "$ans" in
                m|M) break ;;
                ''|*[!0-9]*) say "Invalid selection." ;;
                *) if (( ans >= 1 && ans <= ${#CANDIDATES[@]} )); then WSJTX_EXE="${CANDIDATES[ans-1]}"; else say "Invalid selection."; fi ;;
            esac
        done
    fi
else
    say ""
    say "WSJT-X wurde nicht automatisch gefunden."
fi

while [[ -z "$WSJTX_EXE" ]]; do
    read -r -p "Vollständigen Pfad zu wsjtx oder zur AppImage-Datei eingeben (X = Abbrechen): " p
    [[ "$p" =~ ^[xX]$ ]] && exit 2
    p="${p/#\~/$HOME}"
    if [[ -d "$p" ]]; then
        [[ -x "$p/wsjtx" ]] && p="$p/wsjtx"
        [[ -x "$p/bin/wsjtx" ]] && p="$p/bin/wsjtx"
    fi
    if [[ -f "$p" && -x "$p" ]]; then
        WSJTX_EXE="$(readlink -f "$p" 2>/dev/null || printf '%s' "$p")"
    else
        say "Unter dem angegebenen Pfad wurde kein ausführbares WSJT-X gefunden."
    fi
done
printf '%s' "$WSJTX_EXE" > "$EXE_FILE"

# Wrapper intentionally changes cwd to DATA_DIR. WSJT-X 3.0.2 L10nLoader
# explicitly loads wsjtx_<lang>.qm from the current directory when --language is used.
cat > "$WRAPPER" <<'WRAP'
#!/usr/bin/env bash
set -u
DATA_DIR="$HOME/.local/share/wsjtx-sp1aku/de"
EXE_FILE="$DATA_DIR/wsjtx-executable.path"
if [[ ! -f "$EXE_FILE" ]]; then echo "WSJT-X executable path is missing: $EXE_FILE" >&2; exit 1; fi
WSJTX_EXE="$(cat "$EXE_FILE")"
if [[ ! -x "$WSJTX_EXE" ]]; then echo "WSJT-X executable not found or not executable: $WSJTX_EXE" >&2; exit 1; fi
cd "$DATA_DIR" || exit 1
exec "$WSJTX_EXE" --language=de "$@"
WRAP
chmod +x "$WRAPPER"

cat > "$DESKTOP" <<EOF
[Desktop Entry]
Type=Application
Name=WSJT-X 3.0.2 DE
Comment=Deutsche Übersetzung und Sprachpaket: SP1AKU Czaku
Exec=$WRAPPER
Icon=wsjtx
Terminal=false
Categories=HamRadio;Network;
StartupNotify=true
EOF
chmod +x "$DESKTOP"

cat > "$MANUAL_DESKTOP" <<EOF
[Desktop Entry]
Type=Application
Name=WSJT-X 3.0.2 DE – Handbuch
Comment=Deutsche Übersetzung und Sprachpaket: SP1AKU Czaku
Exec=xdg-open $DATA_DIR/wsjtx-main-3.0.2.html
Icon=help-browser
Terminal=false
Categories=HamRadio;Documentation;
EOF
chmod +x "$MANUAL_DESKTOP"

# Optional replacement of an installed system handbook. This is not required for
# the translated UI. For AppImage installations the internal documentation is
# read-only, so the local manual launcher remains available.
SYSTEM_DOC=""
for p in     "/usr/share/doc/wsjtx/wsjtx-main-3.0.2.html"     "/usr/local/share/doc/wsjtx/wsjtx-main-3.0.2.html"     "/usr/share/wsjtx/doc/wsjtx-main-3.0.2.html"     "/usr/local/share/wsjtx/doc/wsjtx-main-3.0.2.html"; do
    [[ -f "$p" ]] && { SYSTEM_DOC="$p"; break; }
done
if [[ -z "$SYSTEM_DOC" ]]; then
    SYSTEM_DOC="$(find /usr/share/doc /usr/local/share/doc -maxdepth 4 -type f -name 'wsjtx-main-3.0.2.html' -print -quit 2>/dev/null || true)"
fi

if [[ -n "$SYSTEM_DOC" ]]; then
    say ""
    say "Systemhandbuch von WSJT-X gefunden: $SYSTEM_DOC"
    read -r -p "Durch das deutsche Handbuch ersetzen? Das Original wird gesichert. [J/n] " ans || true
    case "${ans:-Y}" in
        n|N) : ;;
        *)
            say "Zum Ersetzen des Systemhandbuchs kann sudo erforderlich sein."
            BACKUP="${SYSTEM_DOC%.html}_EN_BACKUP.html"
            if [[ ! -f "$BACKUP" ]]; then sudo cp -a "$SYSTEM_DOC" "$BACKUP" || true; fi
            if sudo cp -f "$DATA_DIR/wsjtx-main-3.0.2.html" "$SYSTEM_DOC"; then
                printf '%s' "$SYSTEM_DOC" > "$SYSTEM_DOC_FILE"
                printf '%s' "$BACKUP" > "$SYSTEM_DOC_BACKUP_FILE"
            fi
            ;;
    esac
fi

# Refresh menus if utilities are present.
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true

say ""
line
say "FERTIG. WSJT-X über „WSJT-X 3.0.2 DE“ im Anwendungsmenü oder mit wsjtx-de starten."
say "WSJT-X: $WSJTX_EXE"
say "QM: $DATA_DIR/$PKG_QM"
say "Das deutsche Handbuch ist zusätzlich lokal über das Anwendungsmenü verfügbar."
line
