# Jak opublikować projekt na GitHub – krok po kroku

## A. Utworzenie repozytorium
1. Zaloguj się na github.com.
2. Kliknij znak **+** w prawym górnym rogu i wybierz **New repository**.
3. W polu **Repository name** wpisz: `WSJTX-Language-Packs-SP1AKU`.
4. Ustaw **Public**.
5. NIE zaznaczaj tworzenia README, .gitignore ani License – te pliki są już w przygotowanej paczce.
6. Kliknij **Create repository**.

## B. Wgranie zawartości repozytorium
1. Rozpakuj paczkę `WSJTX-Language-Packs-SP1AKU_GITHUB_REPOSITORY.zip` na komputerze.
2. W pustym repozytorium GitHub kliknij **uploading an existing file** albo **Add file → Upload files**.
3. Przeciągnij do przeglądarki CAŁĄ ZAWARTOŚĆ rozpakowanego folderu (README.md, translations, installers, docs itd.). Nie wrzucaj samego ZIP-a jako jedynego pliku.
4. W polu commit message wpisz: `Initial PL/DE language packs for WSJT-X 3.0.2`.
5. Kliknij **Commit changes**.

## C. Utworzenie Release
1. Rozpakuj paczkę `WSJTX-Language-Packs-SP1AKU_RELEASE_v3.0.2-lang-1.0.zip`.
2. W repozytorium kliknij **Releases**.
3. Kliknij **Draft a new release**.
4. Wybierz **Choose a tag → Create new tag**.
5. Wpisz tag: `v3.0.2-lang-1.0`.
6. Release title: `WSJT-X 3.0.2 Language Packs PL / DE – Windows & Linux`.
7. Skopiuj opis z pliku `RELEASE_NOTES.md`.
8. Do pola z plikami Release przeciągnij PIĘĆ plików ZIP znajdujących się w rozpakowanej paczce Releases. Nie musisz wrzucać samej zbiorczej paczki Releases.
9. Opcjonalnie zaznacz **Set as latest release**.
10. Kliknij **Publish release**.

## D. Co aktualizować później
- poprawki tekstów: `translations/`
- skrypty instalacyjne: `installers/`
- podręczniki: `docs/`
- nową gotową wersję dla użytkowników publikuj jako kolejny **Release** z nowym tagiem.
