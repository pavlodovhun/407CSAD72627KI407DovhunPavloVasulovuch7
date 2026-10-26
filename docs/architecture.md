# Архітектура AI-агента

## 1. Які проблеми вирішує агент

Агент `build-engineer` автоматизує типові кроки створення кросплатформного
C++-проєкту: початкову структуру Hello World, збірку через CMake, модульні
тести GoogleTest/CTest і CI на GitHub Actions для Windows, Linux та macOS.
Інструкції задають єдиний порядок роботи, перевірки результатів та поведінку
при конфліктах або помилках, щоб повторний запуск не перезаписував файли та не
повідомляв про успіх без підтвердження перевірками.

## 2. Skills та їхня відповідальність

- **`project-scaffold`** — створює базові файли C++-проєкту: `main.cpp`,
  оголошення й реалізацію `add`, порожні `tests/` і `docs/`, а також
  `README.md`, якщо його ще немає.
- **`build-and-test`** — налаштовує CMake для C++17, бібліотеку `add_lib`,
  програму `hello`, GoogleTest через `FetchContent`, тест `BasicAddition`,
  CTest і платформні скрипти `ci.sh` та `ci.bat`.
- **`github-actions`** — визначає workflow для Ubuntu, Windows і macOS, який
  запускає відповідний CI-скрипт і завантажує вміст `dist/` як артефакт.

## 3. Commands, доступні користувачу

- `/git-init` — перевірити Git-репозиторій і створити або доповнити
  `.gitignore`.
- `/create-project` — створити scaffold C++ Hello World-проєкту.
- `/create-build` — налаштувати CMake, GoogleTest/CTest та CI-скрипти.
- `/create-actions` — створити GitHub Actions workflow.
- `/check` — у режимі лише для читання перевірити файли, збірку, тести,
  workflow і Git-ігнорування; вивести загальний статус `PASSED` або `FAILED`.
- `/init` — послідовно виконати початкове налаштування та фінальну перевірку.

## 4. Передавання даних між етапами

Потік від вхідних параметрів до CI:

```text
project_name=hello
    -> src/
    -> CMakeLists.txt
    -> ci.sh / ci.bat
    -> .github/workflows/ci.yml
```

1. **`project_name` → `src/`:** skill `project-scaffold` приймає `language=C++`
   і `project_name=hello`. Він створює `src/main.cpp`, `src/add.h` і
   `src/add.cpp`; програма виводить `Hello, World!` та використовує `add`.
2. **`src/` → `CMakeLists.txt`:** skill `build-and-test` налаштовує CMake
   відповідно до вихідного коду: компілює `src/add.cpp` у `add_lib`, пов'язує
   бібліотеку з програмою `hello` з `src/main.cpp` і підключає тест із
   `tests/test_basic.cpp`.
3. **`CMakeLists.txt` → `ci.sh` / `ci.bat`:** скрипти конфігурують і збирають
   проєкт, запускають CTest та копіюють виконуваний файл `hello` у `dist/`.
   `ci.sh` призначений для Linux/macOS, `ci.bat` — для Windows.
4. **CI-скрипти → `ci.yml`:** workflow розподіляє запуск між
   `ubuntu-latest`, `windows-latest` і `macos-latest`. У його `run`-кроках
   запускаються лише `./ci.sh` або `ci.bat`; після успішного запуску workflow
   завантажує `dist/` як окремий артефакт для кожної ОС.

## 5. Обробка помилок в оркестраторі `init`

Оркестратор виконує prompt-и строго по порядку: `git-init`, `create-project`,
`create-build`, `create-actions`, `check`. Після кожного етапу він перевіряє
результат і переходить далі лише за успішної перевірки. Якщо етап завершується
помилкою, оркестратор зупиняється, не запускає наступні кроки та звітує про
номер кроку, причину й необхідне виправлення. Незапущені кроки позначаються
`SKIPPED`. Загальний успіх не оголошується без статусу `PASSED` від фінальної
команди `/check`.

## 6. Відповідність файлів ролям

| Роль | Розташування | Призначення |
|---|---|---|
| Agent | `.github/agents/` | Визначення ролі `build-engineer`, його обов'язків і правил роботи |
| Skills | `.github/skills/` | Повторно використовувані інструкції scaffold, збірки/тестування та GitHub Actions |
| Commands | `.github/prompts/` | Виконувані користувачем prompt-и для окремих завдань та їх оркестрації |

## 7. Формат VS Code Copilot

Агент і його інструкції використовують формат VS Code Copilot: **custom agents**
(`.agent.md`), **prompt files** (`.prompt.md`) і **agent skills**
(`SKILL.md`). Ці файли розміщені у `.github/`, щоб налаштування були частиною
репозиторію та доступні його користувачам.
