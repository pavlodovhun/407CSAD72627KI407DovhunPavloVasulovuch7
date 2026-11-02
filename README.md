407CSAD72627KI407DovhunPavloVasulovuch7unPavloVasulovuch7 

## Відомості про роботу

- **ПІП:** Довгунь Павло Васильович
- **Група:** КІ-407
- **Варіант:** 7
- **Технології:** C++, CMake, GoogleTest/CTest

## Опис проєкту

Репозиторій містить налаштування AI-агента для GitHub Copilot у VS Code. Агент призначений для створення кросплатформного C++ Hello World проєкту, його збірки через CMake, запуску юніт-тестів GoogleTest/CTest та налаштування CI на GitHub Actions для Windows, Linux і macOS.

## Запуск агента

1. Відкрийте папку репозиторію у VS Code.
2. Відкрийте Copilot Chat.
3. Виберіть агента `build-engineer`.
4. Виконайте команду `/init`.

## Commands

- `/git-init` — перевірити Git-репозиторій і створити або доповнити `.gitignore`.
- `/create-project` — створити базову структуру C++ Hello World.
- `/create-build` — налаштувати CMake, GoogleTest/CTest і скрипти збірки.
- `/create-actions` — створити або перевірити workflow GitHub Actions.
- `/check` — перевірити структуру, збірку, тести та CI у режимі лише читання.
- `/init` — послідовно виконати початкове налаштування та фінальну перевірку.
