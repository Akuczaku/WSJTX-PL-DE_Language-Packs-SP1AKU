# 🇬🇧 WSJT-X 3.0.2 – Polish & German Language Packs

**Language:** [🇵🇱 Polski](README_PL.md) · 🇬🇧 **English** · [🇩🇪 Deutsch](README_DE.md) · [🏠 Home](README.md)

<table>
<tr>
<td align="center"><img src="assets/banner_pl.png" alt="WSJT-X Polish language pack" width="460"></td>
<td align="center"><img src="assets/banner_de.png" alt="WSJT-X German language pack" width="460"></td>
</tr>
</table>

Unofficial **Polish and German** language packs for **WSJT-X 3.0.2**, prepared by **SP1AKU Czaku**.

> WSJT-X remains the work of its original authors and the WSJT Development Team. The **SP1AKU Czaku** attribution applies to the PL/DE translations, helper documentation and language-package installers, not to WSJT-X itself.

## ⬇️ Download the latest version

<table>
<tr>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_PL_FULL_FIX3_SP1AKU_Czaku_AUTO_PATH.zip"><img src="assets/download_windows_pl.svg" alt="Download Windows PL" width="360"></a></td>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_DE_FULL_FIX3_SP1AKU_Czaku_AUTO_PATH.zip"><img src="assets/download_windows_de.svg" alt="Download Windows DE" width="360"></a></td>
</tr>
<tr>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_LINUX_PL_SP1AKU_Czaku.zip"><img src="assets/download_linux_pl.svg" alt="Download Linux PL" width="360"></a></td>
<td align="center"><a href="../../releases/latest/download/WSJTX_3.0.2_LINUX_DE_SP1AKU_Czaku.zip"><img src="assets/download_linux_de.svg" alt="Download Linux DE" width="360"></a></td>
</tr>
</table>

**Linux PL + DE:** [Download combined package](../../releases/latest/download/WSJTX_3.0.2_LINUX_PL_DE_SP1AKU_Czaku.zip) · [All releases](../../releases/latest)

## Repository contents

- `translations/wsjtx_pl.ts` – Polish Qt translation source
- `translations/wsjtx_de.ts` – German Qt translation source
- `compiled/` – compiled `.qm` language files
- `docs/` – full Polish and German HTML User Guides
- `installers/windows/` – Windows installer scripts with automatic path detection
- `installers/linux/` – Linux installation/uninstallation scripts
- `patches/` – i18n patch for selected hard-coded UI strings in WSJT-X 3.0.2

## Translation status

| Language | Locale | Messages | `unfinished` | Empty | Qt placeholder errors |
|---|---:|---:|---:|---:|---:|
| Polish | pl_PL | 1824 | 0 | 0 | 0 |
| German | de_DE | 1804 | 0 | 0 | 0 |

Standard amateur-radio mode names and abbreviations such as FT8, FT4, Q65, WSPR, CAT, PTT, DXCC, LoTW and Hamlib are kept in their standard technical form where appropriate.

## Windows

The Windows packages detect WSJT-X even when it is installed on a non-standard drive such as `D:` or `E:`. If automatic detection fails, the user can select the installation path manually.

The Polish launcher starts WSJT-X with `--language=pl`; the German launcher uses `--language=de`.

## Linux

For the Polish package:

```bash
chmod +x install_pl.sh uninstall_pl.sh
./install_pl.sh
```

For the German package:

```bash
chmod +x install_de.sh uninstall_de.sh
./install_de.sh
```

## i18n patch

`patches/WSJTX_3.0.2_I18N_HARDCODED_TEXTS.patch` addresses several user-visible strings in WSJT-X 3.0.2 that do not currently pass through Qt `tr()`. A `.qm` file alone cannot translate those strings in an unmodified official `wsjtx.exe`; the patch is intended for developers or source builds.

## Documentation

- [Full Polish User Guide](docs/PL/wsjtx-main-3.0.2.html)
- [Full German User Guide](docs/DE/wsjtx-main-3.0.2.html)

## Language-pack author

**SP1AKU Czaku**

73!

## License notice

This repository contains derivative translation material based on WSJT-X 3.0.2. Original WSJT-X copyright and licensing remain with the WSJT project and its contributors. The original WSJT-X `COPYING` file is included. See also [LICENSE-NOTICE.md](LICENSE-NOTICE.md).
