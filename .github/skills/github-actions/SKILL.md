---
name: github-actions
description: Застосовуй, коли потрібно створити або перевірити GitHub Actions workflow для кросплатформної збірки C++-проєкту на Linux, Windows і macOS.
---

# GitHub Actions

## Очікуваний результат

Створи або узгоджено онови `.github/workflows/ci.yml`. Перед змінами перевір наявний файл і не перезаписуй його без аналізу.

Workflow має відповідати таким вимогам:

- Тригери `push` і `pull_request` лише для гілок `develop` та `master`.
- Одна job зі стратегією matrix:
  - `os: [ubuntu-latest, windows-latest, macos-latest]`;
  - `fail-fast: false`.
- Кроки:
  1. Checkout репозиторію через `actions/checkout@v4`.
  2. На runner-ах, відмінних від Windows, запустити лише `./ci.sh` з `shell: bash`.
  3. На Windows запустити лише `ci.bat` з `shell: cmd`.
  4. Завантажити `dist/` через `actions/upload-artifact@v4`, з унікальним ім'ям `hello-${{ matrix.os }}` і `if-no-files-found: error`.

У `run`-кроках workflow дозволені лише команди запуску `./ci.sh` або `ci.bat`. Не запускай `cmake`, `ctest`, компілятор чи команди збірки безпосередньо з workflow: configure, build, тестування та копіювання до `dist/` виконують відповідні CI-скрипти.

Не додавай облікові дані, конфіденційні значення або кроки для їх читання чи передавання.

## Порядок роботи

1. Переконайся, що `ci.sh` і `ci.bat` існують та виконують configure, build, CTest і копіювання програми до `dist/`.
2. Перевір наявний `.github/workflows/ci.yml`. Зберігай сумісні налаштування, не дублюй тригери, job-и чи кроки; повідом про конфліктні налаштування перед зміною.
3. Налаштуй matrix з трьома вказаними ОС і `fail-fast: false`.
4. Додай розділені за платформою кроки запуску: Bash викликає `./ci.sh` на Linux/macOS, а `cmd` викликає `ci.bat` на Windows.
5. Додай завантаження `dist/` з унікальним ім'ям артефакту для кожної ОС та помилкою, якщо файлів немає.
6. Перевір YAML, структуру workflow, три ОС, команди `run` та відсутність облікових даних або конфіденційних значень.
7. Перед завершенням покажи diff або список змінених файлів і результати перевірок.

## Перевірки

- Переконайся, що YAML валідний: використовуй `actionlint`, якщо він доступний; інакше перевір Python-командою `python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))"`.
- Переконайся, що matrix містить `ubuntu-latest`, `windows-latest` і `macos-latest`, а `fail-fast` має значення `false`.
- Переконайся, що обидва тригери охоплюють тільки `develop` і `master`.
- Переконайся, що всі `run`-кроки викликають тільки `./ci.sh` або `ci.bat`; прямі команди збірки й тестування заборонені.
- Переконайся, що крок завантаження використовує `actions/upload-artifact@v4`, шлях `dist/`, ім'я `hello-${{ matrix.os }}` і `if-no-files-found: error`.
- Переконайся, що workflow не містить слів `token`, `password` або `secret` без урахування регістру.

## Типова помилка

**`ci.sh` не має прав на виконання.** Перевір, що файл запускається як `./ci.sh`, має executable bit у Git і що скрипт завершується з ненульовим кодом при помилці. Якщо право відсутнє, встанови його через `git update-index --chmod=+x ci.sh`; не замінюй команду запуску на обхідний спосіб.

## Приклад

**Вхід:**

```text
Створи GitHub Actions workflow для ci.sh і ci.bat на Ubuntu, Windows та macOS.
Запускайся для push і pull_request у develop та master.
```

**Очікуваний результат:**

```text
Створено .github/workflows/ci.yml з однією job і matrix для трьох ОС.
Linux/macOS запускають ./ci.sh через Bash, Windows запускає ci.bat через cmd.
Артефакт dist/ завантажується окремо для кожної ОС.
YAML валідний, workflow перевірений.
```
