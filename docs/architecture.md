# Архітектура AI-агента

## 1. Які проблеми вирішує агент

Агент `build-engineer` автоматизує типові етапи створення та перевірки кросплатформного C++ Hello World проєкту:

- створює початкову структуру вихідного коду;
- налаштовує CMake для C++17, GoogleTest і CTest;
- надає скрипти для відтворюваної збірки та запуску тестів;
- налаштовує GitHub Actions для Windows, Linux і macOS;
- перевіряє очікувану структуру, результати збірки, тести й налаштування Git.

Інструкції обмежують зміни запитаною областю, вимагають перевіряти наявні файли перед редагуванням і не оголошувати успіх, якщо перевірки не пройшли.

## 2. Skills та їх призначення

- [`project-scaffold`](../.github/skills/project-scaffold/SKILL.md) — створює базовий C++ scaffold: `src/main.cpp`, `src/add.h`, `src/add.cpp`, порожні `tests/` і `docs/`, а також `README.md`, якщо його ще немає.
- [`build-and-test`](../.github/skills/build-and-test/SKILL.md) — налаштовує CMake, бібліотеку `add_lib`, виконуваний файл `hello`, GoogleTest/CTest, тест `BasicAddition` і скрипти збірки для Windows та Unix-подібних платформ.
- [`github-actions`](../.github/skills/github-actions/SKILL.md) — створює або перевіряє GitHub Actions workflow для трьох ОС, запускає наявні CI-скрипти та завантажує артефакт.

## 3. Commands для користувача

Prompt-файли в `.github/prompts/` доступні як slash-команди в Copilot Chat:

- `/git-init` — перевіряє Git-репозиторій і створює або доповнює `.gitignore`.
- `/create-project` — створює базовий C++ scaffold.
- `/create-build` — налаштовує CMake, GoogleTest/CTest і локальні CI-скрипти.
- `/create-actions` — створює або перевіряє GitHub Actions workflow.
- `/check` — виконує перевірки проєкту в режимі лише читання та повертає `PASS`/`FAIL`.
- `/init` — послідовно запускає повний workflow від початкової перевірки Git до фінальної перевірки.

## 4. Дані між етапами

Інформація передається через параметри workflow та файли репозиторію:

1. `project_name=hello` задає назву проєкту для scaffold.
2. Етап `project-scaffold` використовує назву та мову `C++`, щоб створити `src/main.cpp`, `src/add.h` і `src/add.cpp`. `main.cpp` друкує `Hello, World!` і використовує `add`.
3. `CMakeLists.txt` споживає ці вихідні файли: компілює `src/add.cpp` у `add_lib`, пов'язує бібліотеку з виконуваним файлом `hello` та налаштовує GoogleTest/CTest для `tests/test_basic.cpp`.
4. `ci.sh` і `ci.bat` виконують configure, build і CTest, а потім копіюють зібраний `hello` до `dist/`. Шлях до виконуваного файла враховує відмінності платформ.
5. `.github/workflows/ci.yml` вибирає потрібний скрипт для кожної ОС: `./ci.sh` для Linux/macOS і `ci.bat` для Windows. Після успішного CI workflow завантажує вміст `dist/` як окремий платформний артефакт.

Отже, потік має вигляд:

```text
project_name
    -> src/
    -> CMakeLists.txt
    -> ci.sh / ci.bat
    -> .github/workflows/ci.yml
```

## 5. Обробка помилок оркестратором `init`

[`/init`](../.github/prompts/init.prompt.md) виконує п'ять етапів строго послідовно: `/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check`. Після кожного етапу він перевіряє результат і переходить далі лише після успіху.

Якщо етап завершується помилкою, має конфлікт або не проходить обов'язкову перевірку, оркестратор зупиняється та не запускає наступні етапи. Він повідомляє номер і назву етапу, причину та що потрібно виправити; у підсумковій таблиці позначає наступні етапи як `NOT RUN`. Загальний успіх дозволений лише тоді, коли всі кроки пройшли, а `/check` завершився зі статусом `PASSED`.

## 6. Відповідність файлів ролям

| Роль | Розташування | Призначення |
|---|---|---|
| `agent` | `.github/agents/` | Визначення ролі, меж відповідальності, інструментів і правил роботи агента. |
| `skills` | `.github/skills/` | Спеціалізовані інструкції для scaffold, збірки/тестування та GitHub Actions. |
| `commands` | `.github/prompts/` | Виконувані користувачем завдання та послідовний оркестратор `/init`. |

## 7. Формат VS Code Copilot

Конфігурація використовує формат кастомізації VS Code Copilot: **custom agents** (`.agent.md`), **prompt files** (`.prompt.md`) та **agent skills** (`SKILL.md`). Ці файли надають інструкції Copilot Chat; вони самі по собі не є вихідним кодом C++ або файлами збірки.
