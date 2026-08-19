#!/usr/bin/env bash
# ============================================================================
# Deutsche Übersetzung und Sprachpaket: SP1AKU Czaku
# Linux uninstaller. Does not remove the original WSJT-X installation.
# ============================================================================
set -u
LANG_CODE="de"
DATA_DIR="$HOME/.local/share/wsjtx-sp1aku/$LANG_CODE"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
SYSTEM_DOC_FILE="$DATA_DIR/system-doc.path"
SYSTEM_DOC_BACKUP_FILE="$DATA_DIR/system-doc-backup.path"

printf '%s\n' '======================================================================'
printf '%s\n' 'WSJT-X 3.0.2 DE — Sprachpaket entfernen'
printf '%s\n' '======================================================================'

if [[ -f "$SYSTEM_DOC_FILE" && -f "$SYSTEM_DOC_BACKUP_FILE" ]]; then
    SYSTEM_DOC="$(cat "$SYSTEM_DOC_FILE")"
    BACKUP="$(cat "$SYSTEM_DOC_BACKUP_FILE")"
    if [[ -f "$BACKUP" ]]; then
        read -r -p "Eine Sicherung des Systemhandbuchs wurde gefunden. Original wiederherstellen? [J/n] " ans || true
        case "${ans:-Y}" in
            n|N) : ;;
            *) sudo cp -f "$BACKUP" "$SYSTEM_DOC" && sudo rm -f "$BACKUP" || true ;;
        esac
    fi
fi

rm -f "$BIN_DIR/wsjtx-de"
rm -f "$APP_DIR/wsjtx-de.desktop" "$APP_DIR/wsjtx-de-manual.desktop"
rm -rf "$DATA_DIR"
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
printf '%s\n' 'Das DE-Sprachpaket wurde entfernt. Die ursprüngliche WSJT-X-Installation bleibt unverändert.'
