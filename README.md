# 407CSAD72627KI407DovhunPavloVasulovuch7

**Студент:** Довгунь Павло Васильович  
**Група:** КІ-407  
**Варіант:** 7  
**Технології:** C++, CMake, GoogleTest/CTest

## Опис проєкту

Навчальний проєкт з AI-агентом для VS Code Copilot. Агент призначений для
створення кросплатформного C++-проєкту Hello World, налаштування збірки через
CMake, модульного тесту функції додавання за допомогою GoogleTest/CTest та CI
у GitHub Actions для Windows, Linux і macOS.

## Запуск агента

1. Відкрийте папку репозиторію у VS Code.
2. Відкрийте Copilot Chat.
3. Виберіть агента `build-engineer`.
4. Виконайте команду `/init`.

## Команди агента

- `/git-init` — перевірити Git-репозиторій і створити або доповнити `.gitignore`.
- `/create-project` — створити scaffold C++-проєкту Hello World.
- `/create-build` — налаштувати CMake, GoogleTest/CTest та скрипти збірки.
- `/create-actions` — створити GitHub Actions workflow для Windows, Linux і macOS.
- `/check` — перевірити структуру, збірку, тести, workflow та Git-ігнорування.
- `/init` — послідовно виконати налаштування проєкту й фінальну перевірку.
