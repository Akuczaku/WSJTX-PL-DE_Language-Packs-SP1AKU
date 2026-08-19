# WSJT-X 3.0.2 – Polish & German Language Packs

![Polish language pack](assets/banner_pl.png)

Nieoficjalne pakiety językowe **PL / DE** dla **WSJT-X 3.0.2**, przygotowane przez **SP1AKU Czaku**.

> **Ważne:** WSJT-X jest projektem jego oryginalnych autorów i WSJT Development Team. Oznaczenie **SP1AKU Czaku** dotyczy polskich/niemieckich tłumaczeń, dokumentacji pomocniczej i przygotowania pakietów instalacyjnych – nie autorstwa programu WSJT-X.

## ⬇️ Pobierz najnowszą wersję

Kliknij odpowiedni przycisk — prowadzi bezpośrednio do pliku z **najnowszego GitHub Release**.

<table>
<tr>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_PL_FULL_FIX3_SP1AKU_Czaku_AUTO_PATH.zip"><img src="assets/download_windows_pl.svg" alt="Pobierz Windows PL" width="360"></a></td>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_DE_FULL_FIX3_SP1AKU_Czaku_AUTO_PATH.zip"><img src="assets/download_windows_de.svg" alt="Download Windows DE" width="360"></a></td>
</tr>
<tr>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_LINUX_PL_SP1AKU_Czaku.zip"><img src="assets/download_linux_pl.svg" alt="Pobierz Linux PL" width="360"></a></td>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_LINUX_DE_SP1AKU_Czaku.zip"><img src="assets/download_linux_de.svg" alt="Download Linux DE" width="360"></a></td>
</tr>
</table>

**Pakiet Linux PL + DE w jednym archiwum:** [Pobierz Linux PL+DE](../../releases/latest/download/WSJTX_3.0.2_LINUX_PL_DE_SP1AKU_Czaku.zip)

**Wszystkie wydania:** [GitHub Releases](../../releases/latest)

> Linki `releases/latest/download/...` zawsze wskazują na pliki dołączone do aktualnego wydania oznaczonego jako **Latest**.

## Co zawiera repozytorium

- polskie źródło Qt: `translations/wsjtx_pl.ts`
- niemieckie źródło Qt: `translations/wsjtx_de.ts`
- skompilowane pliki: `compiled/wsjtx_pl.qm`, `compiled/wsjtx_de.qm`
- pełne podręczniki HTML PL i DE w `docs/`
- instalatory Windows z automatycznym wykrywaniem ścieżki w `installers/windows/`
- instalatory Linux w `installers/linux/`
- patch i18n dla tekstów wpisanych na sztywno w WSJT-X 3.0.2 w `patches/`

## Status tłumaczeń

| Język | Locale | Wpisy | `unfinished` | Puste | Błędy placeholderów Qt |
|---|---:|---:|---:|---:|---:|
| Polski | pl_PL | 1824 | 0 | 0 | 0 |
| Niemiecki | de_DE | 1804 | 0 | 0 | 0 |

Nazwy trybów i standardowe skróty krótkofalarskie, np. FT8, FT4, Q65, WSPR, CAT, PTT, DXCC, LoTW i Hamlib, pozostają w standardowej formie tam, gdzie jest to właściwe.

## Pobieranie gotowych paczek

Najwygodniej użyć przycisków **Pobierz najnowszą wersję** na górze strony. Gotowe archiwa znajdują się w sekcji **Releases**.

## Windows

Pakiety Windows wykrywają instalację WSJT-X również na niestandardowym dysku, np. `D:` lub `E:`. Jeśli instalacja nie zostanie znaleziona automatycznie, użytkownik może podać ścieżkę ręcznie.

Polski launcher uruchamia WSJT-X z `--language=pl`, niemiecki z `--language=de`.

## Linux

Po rozpakowaniu odpowiedniego pakietu:

```bash
chmod +x install_pl.sh uninstall_pl.sh
./install_pl.sh
```

lub dla niemieckiego:

```bash
chmod +x install_de.sh uninstall_de.sh
./install_de.sh
```

## Patch i18n

`patches/WSJTX_3.0.2_I18N_HARDCODED_TEXTS.patch` dotyczy kilku tekstów interfejsu, które w oryginalnym kodzie WSJT-X 3.0.2 nie przechodzą przez mechanizm `tr()` Qt. Sam plik `.qm` nie może przetłumaczyć takich napisów w niezmodyfikowanym oficjalnym `wsjtx.exe`; patch jest przeznaczony dla deweloperów / kompilacji ze źródeł.

## Dokumentacja

- [Podręcznik PL](docs/PL/wsjtx-main-3.0.2.html)
- [Handbuch DE](docs/DE/wsjtx-main-3.0.2.html)

## Autor pakietów językowych

**SP1AKU Czaku**

73!

## License / licensing notice

This repository contains derivative translation material based on WSJT-X 3.0.2. Original WSJT-X copyright and licensing remain with the WSJT project and its contributors. The original WSJT-X `COPYING` file is included in this repository. See also [LICENSE-NOTICE.md](LICENSE-NOTICE.md).
