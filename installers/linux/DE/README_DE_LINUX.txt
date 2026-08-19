WSJT-X 3.0.2 — LINUX-SPRACHPAKET DE
Deutsche Übersetzung und Sprachpaket: SP1AKU Czaku

INSTALLATION
1. Das ZIP-Archiv vollständig entpacken.
2. Ein Terminal im entpackten Ordner öffnen.
3. Falls nötig Ausführungsrechte setzen:
   chmod +x install_de.sh uninstall_de.sh
4. Starten:
   ./install_de.sh
5. Der Installer sucht wsjtx sowie typische AppImage-Pfade. Wenn nichts gefunden
   wird, kann der Pfad zu wsjtx/AppImage manuell angegeben werden.
6. Danach über "WSJT-X 3.0.2 DE" im Anwendungsmenü oder mit
   ~/.local/bin/wsjtx-de starten.

FUNKTIONSWEISE
Das Sprachpaket wird installiert nach:
  ~/.local/share/wsjtx-sp1aku/de/wsjtx_de.qm
Der Launcher wechselt in dieses Verzeichnis und startet:
  wsjtx --language=de
WSJT-X 3.0.2 kann wsjtx_de.qm aus dem aktuellen Arbeitsverzeichnis laden.
Für die Benutzeroberfläche ist daher kein Eingriff in /usr erforderlich.

HANDBUCH
Das vollständige deutsche HTML-Handbuch wird lokal installiert und erhält einen
separaten Menüeintrag. Wird ein systemweites wsjtx-main-3.0.2.html erkannt, fragt
der Installer, ob es ersetzt werden soll; vorher wird _EN_BACKUP.html angelegt.
Bei AppImage ist die interne Dokumentation schreibgeschützt, daher bleibt der
separate Handbuch-Launcher verfügbar.

ENTFERNEN
  ./uninstall_de.sh
Entfernt nur das DE-Sprachpaket und seine Launcher, nicht WSJT-X selbst.
Ein ersetztes Systemhandbuch kann aus der Sicherung wiederhergestellt werden.

HINWEIS ZUM PATCH
WSJTX_3.0.2_I18N_HARDCODED_TEXTS.patch betrifft einige hart codierte Texte im
WSJT-X-3.0.2-Quellcode. Er ist nur beim Kompilieren aus den Quellen relevant und
für die normale Installation des Sprachpakets nicht erforderlich.

WSJT-X bleibt das Projekt seiner ursprünglichen Autoren und des WSJT Development Teams.
Die Kennzeichnung SP1AKU Czaku bezieht sich auf Übersetzung und Paketierung.
