---
name: github-actions
description: "Застосовуй для створення або перевірки GitHub Actions CI workflow для C++/CMake проєкту на Linux, Windows і macOS."
---

# GitHub Actions

Створи або перевір кросплатформний GitHub Actions workflow, який використовує наявні локальні скрипти CI. Не додавай конфіденційних даних до workflow.

## Вхід

Перед початком перевір, що в репозиторії доступні `ci.sh` і `ci.bat`. Workflow має запускати наявний CI-скрипт для відповідної платформи.

## Вихід

Створи `.github/workflows/ci.yml` з такими властивостями:

- Тригери `push` і `pull_request` лише для гілок `develop` та `master`.
- Одна job зі стратегією matrix:
  - `os: [ubuntu-latest, windows-latest, macos-latest]`
  - `fail-fast: false`
- Кроки:
  1. Checkout репозиторію.
  2. Запуск `./ci.sh` на Linux і macOS із `shell: bash`; запуск `ci.bat` на Windows із `shell: cmd`.
  3. Завантаження каталогу `dist/` через `actions/upload-artifact@v4`, з унікальним ім'ям `hello-${{ matrix.os }}` і `if-no-files-found: error`.

У `run` кроків workflow запускай тільки `ci.sh` або `ci.bat` на відповідній платформі. Не додавай туди прямі команди `cmake`, `ctest`, конфігурації чи копіювання файлів: ці дії належать скриптам CI.

## Порядок роботи

1. Перевір наявність `.github/workflows/ci.yml`, `ci.sh` і `ci.bat`; прочитай наявний вміст перед змінами.
2. Якщо workflow вже існує, перевір його на відповідність вимогам і редагуй без дублювання тригерів, jobs чи кроків.
3. Переконайся, що скрипти збірки передбачені для трьох платформ і зберігають результат у `dist/`.
4. Не перезаписуй несумісний workflow мовчки: поясни конфлікт і збережи наявні зміни.
5. Не додавай secrets або інші чутливі значення у файли, команди, вивід чи звіти.

## Перевірки

- Переконайся, що YAML синтаксично валідний. Використай наявний `actionlint`, якщо він доступний; якщо його немає, скористайся стандартним синтаксичним парсером YAML у вже встановленій мові, наприклад `ruby -e "require 'yaml'; YAML.load_file('.github/workflows/ci.yml')"`, без встановлення додаткових пакетів. Не вимагаюй PyYAML як обов'язкову залежність.
- Переконайся, що workflow містить `ubuntu-latest`, `windows-latest` і `macos-latest`, а matrix має `fail-fast: false`.
- Перевір тригери `push` і `pull_request` для `develop` та `master`.
- Перевір, що в кожному `run` кроці запускається лише потрібний CI-скрипт, а прямі команди `cmake`/`ctest` відсутні.
- Переконайся, що upload-крок використовує `actions/upload-artifact@v4`, шлях `dist/`, ім'я `hello-${{ matrix.os }}` та `if-no-files-found: error`.
- Переконайся, що в workflow немає слів `token`, `password` або `secret` без урахування регістру.
- Не заявляй про проходження workflow на GitHub, якщо його фактично не запускали.

## Типова помилка

Якщо `ci.sh` не має прав на виконання, виправ це в Git-індексі командою `git update-index --chmod=+x ci.sh` і перевір режим файла. Не замінюй крок Linux/macOS прямими командами збірки або іншими обхідними рішеннями.

## Приклад

**Вхід**

```text
Налаштуй GitHub Actions для C++ проєкту з наявними ci.sh та ci.bat.
```

**Очікуваний результат**

```text
.github/workflows/ci.yml

Перевірено:
- push і pull_request для develop та master
- matrix: ubuntu-latest, windows-latest, macos-latest; fail-fast: false
- Linux/macOS запускають лише ./ci.sh (bash), Windows — ci.bat (cmd)
- завантажується dist/ як hello-${{ matrix.os }}; відсутність файлів завершує крок помилкою
- YAML валідний; заборонених слів у workflow немає
```
