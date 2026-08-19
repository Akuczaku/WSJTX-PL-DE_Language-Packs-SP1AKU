WSJT-X 3.0.2 — PAKIET JĘZYKOWY LINUX PL
Polskie tłumaczenie i pakiet językowy: SP1AKU Czaku

INSTALACJA
1. Rozpakuj całe archiwum ZIP.
2. Otwórz terminal w rozpakowanym katalogu.
3. Nadaj prawa wykonywania (jeśli system je zgubił):
   chmod +x install_pl.sh uninstall_pl.sh
4. Uruchom:
   ./install_pl.sh
5. Instalator znajdzie polecenie wsjtx lub typowe pliki AppImage. Jeśli nie znajdzie,
   pozwoli wskazać plik wsjtx/AppImage ręcznie.
6. Uruchamiaj z menu: "WSJT-X 3.0.2 PL" albo poleceniem:
   ~/.local/bin/wsjtx-pl

JAK TO DZIAŁA
Pakiet instaluje tłumaczenie do:
  ~/.local/share/wsjtx-sp1aku/pl/wsjtx_pl.qm
Launcher przechodzi do tego katalogu i uruchamia:
  wsjtx --language=pl
WSJT-X 3.0.2 sam obsługuje ładowanie pliku wsjtx_pl.qm z bieżącego katalogu,
więc do samego interfejsu nie trzeba modyfikować /usr ani używać sudo.

PODRĘCZNIK
Pełny polski podręcznik jest instalowany lokalnie i dostaje osobny wpis w menu.
Jeśli wykryty zostanie systemowy wsjtx-main-3.0.2.html, instalator zapyta,
czy podmienić go na polski. Przed podmianą tworzy kopię _EN_BACKUP.html.
Dla AppImage dokumentacja wewnątrz obrazu jest tylko do odczytu — korzystaj wtedy
z osobnego launchera podręcznika.

USUWANIE
  ./uninstall_pl.sh
Usuwa wyłącznie pakiet PL, launcher i lokalne pliki. Nie odinstalowuje WSJT-X.
Jeśli systemowy podręcznik był podmieniony, skrypt proponuje przywrócenie kopii EN.

UWAGA O PATCHU
Plik WSJTX_3.0.2_I18N_HARDCODED_TEXTS.patch dotyczy kilku tekstów wpisanych
na sztywno w kodzie WSJT-X 3.0.2. Patch ma znaczenie tylko przy kompilacji WSJT-X
ze źródeł; nie jest wymagany do zwykłej instalacji pakietu językowego.

WSJT-X pozostaje projektem jego oryginalnych autorów i WSJT Development Team.
Oznaczenie SP1AKU Czaku dotyczy polskiego tłumaczenia i przygotowania pakietu.
