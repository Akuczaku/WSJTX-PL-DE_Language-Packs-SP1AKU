#!/usr/bin/env bash
# ============================================================================
# Polskie tłumaczenie i pakiet językowy: SP1AKU Czaku
# Linux uninstaller. Does not remove the original WSJT-X installation.
# ============================================================================
set -u
LANG_CODE="pl"
DATA_DIR="$HOME/.local/share/wsjtx-sp1aku/$LANG_CODE"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
SYSTEM_DOC_FILE="$DATA_DIR/system-doc.path"
SYSTEM_DOC_BACKUP_FILE="$DATA_DIR/system-doc-backup.path"

printf '%s\n' '======================================================================'
printf '%s\n' 'WSJT-X 3.0.2 PL — usuwanie pakietu językowego'
printf '%s\n' '======================================================================'

if [[ -f "$SYSTEM_DOC_FILE" && -f "$SYSTEM_DOC_BACKUP_FILE" ]]; then
    SYSTEM_DOC="$(cat "$SYSTEM_DOC_FILE")"
    BACKUP="$(cat "$SYSTEM_DOC_BACKUP_FILE")"
    if [[ -f "$BACKUP" ]]; then
        read -r -p "Znaleziono kopię systemowego podręcznika. Przywrócić oryginał? [T/n] " ans || true
        case "${ans:-Y}" in
            n|N) : ;;
            *) sudo cp -f "$BACKUP" "$SYSTEM_DOC" && sudo rm -f "$BACKUP" || true ;;
        esac
    fi
fi

rm -f "$BIN_DIR/wsjtx-pl"
rm -f "$APP_DIR/wsjtx-pl.desktop" "$APP_DIR/wsjtx-pl-manual.desktop"
rm -rf "$DATA_DIR"
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
printf '%s\n' 'Pakiet PL został usunięty. Oryginalna instalacja WSJT-X pozostała bez zmian.'
