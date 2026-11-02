

1\. Я роблю лабораторну роботу: AI-агент для VS Code Copilot, який у репозиторії

&#x20;  генерує кросплатформний C++ проєкт Hello World (CMake + GoogleTest/CTest) і CI

&#x20;  на GitHub Actions (Windows, Linux, macOS).

&#x20;  Зараз я в гілці develop і створюю ТІЛЬКИ інструкції агента (manifest, skills,

&#x20;  prompts-команди, документацію). Не створюй src/, tests/, CMakeLists.txt, ci.yml, ci.sh, ci.bat:

&#x20;  їх згенерує агент пізніше в гілці feature.

&#x20;  Файли створюй по одному, коли я попрошу. Мова інструкцій: українська,

&#x20;  імена файлів і команд: англійською.

2\. Створи файл .github/agents/build-engineer.agent.md з YAML frontmatter

&#x20;  (description, tools) і розділами:

&#x20;  1. Роль: build engineer для C++/CMake проєктів.

&#x20;  2. Область відповідальності: scaffold, збірка, юніт-тести, CI.

&#x20;  3. Доступні skills: project-scaffold, build-and-test, github-actions (з шляхами).

&#x20;  4. Доступні commands: git-init, create-project, create-build, create-actions,

&#x20;     check, init (з коротким описом).

&#x20;  5. Правила роботи з файлами: ніколи не перезаписувати наявні файли без

&#x20;     перевірки; ідемпотентність (повторний запуск не дублює вміст); показувати

&#x20;     diff/список змін перед завершенням.

&#x20;  6. Заборонені дії: видалення файлів, git push --force, переписування історії,

&#x20;     зміна захисту гілок, робота з секретами/токенами, публікація даних.

&#x20;  7. Порядок роботи.

&#x20;  8. Критерії успішного завершення: існує виконуваний файл hello; тест BasicAddition проходить; ci.yml містить ubuntu/windows/macos і лише викликає ci.sh/ci.bat; build/ і dist/ не під Git; check завершується без помилок.

&#x20;  9. Поведінка при помилці: зупинитись, показати причину, не вважати роботу успішною.

3\. Створи .github/skills/project-scaffold/SKILL.md.

&#x20;  Frontmatter: name: project-scaffold, description (коли застосовувати).

&#x20;  Вхід: language=C++, project\_name=hello.

&#x20;  Вихід: src/main.cpp (друкує "Hello, World!" і використовує add), src/add.h,

&#x20;  src/add.cpp (int add(int,int)), порожні каталоги tests/ та docs/, README (якщо немає).

&#x20;  Правила: не перезаписувати наявні файли; якщо файл існує і відрізняється, повідомити.

&#x20;  Перевірки: src/main.cpp існує; вказана команда запуску (./build/hello або

&#x20;  build\\Release\\hello.exe). Типова помилка: файл вже існує з іншим вмістом.

&#x20;  Додай приклад входу та очікуваного результату.

4\. Створи .github/skills/build-and-test/SKILL.md.

&#x20;  Frontmatter: name: build-and-test, description (коли застосовувати).

&#x20;  Вхід: наявні src/add.h, src/add.cpp, src/main.cpp.

&#x20;  Вихід: CMakeLists.txt (cmake\_minimum\_required 3.14, C++17, бібліотека add\_lib,

&#x20;  виконуваний файл hello, GoogleTest через FetchContent, enable\_testing,

&#x20;  gtest\_discover\_tests), tests/test\_basic.cpp з тестом BasicAddition, скрипти

&#x20;  ci.sh (bash, set -euo pipefail) і ci.bat, які виконують configure, build, ctest

&#x20;  і копіюють hello у dist/. ci.sh має бути виконуваним (git update-index --chmod=+x).

&#x20;  ci.bat після кожної команди перевіряє %errorlevel% і завершується з ненульовим кодом при помилці.

&#x20;  Перевірки: cmake configure/build проходять, ctest показує BasicAddition passed,

&#x20;  існує виконуваний hello. Типові помилки: не знайдено компілятор; на Windows hello

&#x20;  лежить у build/Release; на Linux/macOS у build/. Ідемпотентність: не дублювати

&#x20;  блоки в CMakeLists.txt.

&#x20;  Додай приклад входу та очікуваного результату.

5\. Створи .github/skills/github-actions/SKILL.md.

&#x20;  Frontmatter: name: github-actions, description (коли застосовувати).

&#x20;  Вихід: .github/workflows/ci.yml: тригери push і pull\_request на develop та master;

&#x20;  одна job з matrix os: \[ubuntu-latest, windows-latest, macos-latest], fail-fast: false;

&#x20;  кроки: checkout, запуск ./ci.sh (не Windows, shell: bash) або ci.bat (Windows, shell: cmd),

&#x20;  upload-artifact з dist/ (actions/upload-artifact@v4, унікальне ім'я hello-${{ matrix.os }},

&#x20;  if-no-files-found: error). ВАЖЛИВО: у кроках run файлу ci.yml НЕ має бути команд cmake/ctest напряму,

&#x20;  лише запуск ci.sh/ci.bat. Без секретів.

&#x20;  Перевірки: YAML валідний (python -c "import yaml..." або actionlint, якщо є);

&#x20;  у файлі є три ОС; немає слів token/password/secret.

&#x20;  Типова помилка: ci.sh без прав на виконання.

&#x20;  Додай приклад входу та очікуваного результату.

6\. Створи .github/prompts/git-init.prompt.md.

&#x20;  Frontmatter: description, agent: build-engineer.

&#x20;  Розділи: Передумови, Дії, Очікувані файли, Команди перевірки, Повідомлення про помилку, Ідемпотентність.

&#x20;  Дії: перевірити, що поточний каталог є git-репозиторієм (git rev-parse); створити .gitignore або ДОПОВНИТИ його без дублів рядками build/, dist/, out/, .vs/, \*.exe, \*.obj, \*.o, CMakeCache.txt, CMakeFiles/, .env, \*.pem, \*.key; показати git status.

&#x20;  Нічого не видаляти.

7\. Створи .github/prompts/create-project.prompt.md.

&#x20;  Frontmatter: description, agent: build-engineer.

&#x20;  Розділи: Передумови (git-репозиторій), Дії (виконати інструкції зі skill .github/skills/project-scaffold/SKILL.md з language=C++, project\_name=hello), Очікувані файли (src/main.cpp, src/add.h, src/add.cpp), Команди перевірки (src/main.cpp існує), Повідомлення про помилку, Ідемпотентність.

8\. Створи .github/prompts/create-build.prompt.md.

&#x20;  Frontmatter: description, agent: build-engineer.

&#x20;  Розділи: Передумови (є src/main.cpp, src/add.h, src/add.cpp), Дії (виконати skill .github/skills/build-and-test/SKILL.md), Очікувані файли (CMakeLists.txt, tests/test\_basic.cpp, ci.sh, ci.bat), Команди перевірки, Повідомлення про помилку, Ідемпотентність.

9\. Створи .github/prompts/create-actions.prompt.md.

&#x20;  Frontmatter: description, agent: build-engineer.

&#x20;  Розділи: Передумови (є ci.sh і ci.bat), Дії (виконати skill .github/skills/github-actions/SKILL.md), Очікувані файли (.github/workflows/ci.yml), Команди перевірки (валідність YAML, три ОС, виклик лише ci.sh/ci.bat), Повідомлення про помилку, Ідемпотентність.

10\. Створи .github/prompts/check.prompt.md.

&#x20;   Frontmatter: description, agent: build-engineer.

&#x20;   Режим: ТІЛЬКИ ЧИТАННЯ. Не створювати і не змінювати файли проєкту (тимчасові каталоги build/ дозволені, вони в .gitignore).

&#x20;   Виконати перевірки і вивести таблицю PASS/FAIL:

&#x20;   1. Існують .github/agents/build-engineer.agent.md і три SKILL.md.

&#x20;   2. Кожен skill має розділи Вхід, Вихід, Перевірки.

&#x20;   3. Існують src/main.cpp, src/add.h, src/add.cpp, tests/test\_basic.cpp, CMakeLists.txt, ci.sh, ci.bat.

&#x20;   4. cmake -S . -B build \&\& cmake --build build --config Release проходять.

&#x20;   5. ctest --test-dir build -C Release --output-on-failure: BasicAddition passed.

&#x20;   6. Існує виконуваний файл hello.

&#x20;   7. ci.yml: валідний YAML, містить ubuntu-latest, windows-latest, macos-latest, у кроках run викликає лише ci.sh/ci.bat (без прямих команд cmake/ctest).

&#x20;   8. git ls-files не містить build/, dist/, .env, \*.key, \*.pem.

&#x20;   9. .gitignore містить build/ і dist/.

&#x20;   Якщо є хоча б один FAIL: вказати який саме і завершити зі статусом FAILED. Якщо все PASS: статус PASSED.

&#x20;   Додай розділи: Передумови, Повідомлення про помилку.

11\. Створи .github/prompts/init.prompt.md.

&#x20;   Frontmatter: description, agent: build-engineer.

&#x20;   Ти оркестратор. Виконуй кроки СТРОГО по порядку, читаючи і виконуючи інструкції з файлів:

&#x20;   1. .github/prompts/git-init.prompt.md

&#x20;   2. .github/prompts/create-project.prompt.md

&#x20;   3. .github/prompts/create-build.prompt.md

&#x20;   4. .github/prompts/create-actions.prompt.md

&#x20;   5. .github/prompts/check.prompt.md

&#x20;   Після кожного кроку перевіряй результат. Якщо крок завершився помилкою: ЗУПИНИСЬ, не виконуй наступні, виведи звіт (який крок, причина, що виправити). Не оголошуй успіх без PASSED від check.

&#x20;   Повторний запуск не повинен руйнувати чи дублювати наявні файли.

&#x20;   У кінці виведи таблицю: крок, статус, створені/змінені файли.

&#x20;   Додай розділи: Передумови, Очікувані файли, Повідомлення про помилку.

12\. Онови README.md (зараз там лише назва репозиторія, збережи її): ПІП Довгунь Павло Васильович, група КІ-407, варіант 7 (C++, CMake, GoogleTest/CTest), короткий опис проєкту, розділ "Запуск агента": відкрити папку у VS Code, відкрити Copilot Chat, вибрати агента build-engineer, виконати /init. Додай список commands. Залиш плейсхолдери для ПІП і групи.

13\. Створи docs/architecture.md з розділами:

&#x20;   1. Які проблеми вирішує агент.

&#x20;   2. Які skills використовує і за що вони відповідають.

&#x20;   3. Які commands доступні користувачу.

&#x20;   4. Які дані передаються між етапами (project\_name -> src/ -> CMakeLists.txt -> ci.sh/ci.bat -> ci.yml).

&#x20;   5. Як оркестратор init обробляє помилки.

&#x20;   6. Таблиця відповідності файлів ролям: agent -> .github/agents/, skills -> .github/skills/, commands -> .github/prompts/.

&#x20;   7. Примітка, що використано формат VS Code Copilot (custom agents, prompt files, agent skills).













1. Analyze this codebase and create a .github/copilot-instructions.md file to help future Copilot sessions work effectively in this repository.

   ## What to include

   1. **Build, test, and lint commands** - If they exist. Include how to run a single test, not just the full suite
   2. **High-level architecture** - Focus on the "big picture" that requires reading multiple files to understand
   3. **Key conventions** - Patterns specific to this codebase that aren't obvious from reading a single file

   ## What NOT to include

   * Generic development practices (e.g., "write unit tests", "use meaningful names")
   * Obvious instructions that any developer would know
   * Exhaustive file/directory listings that can be easily discovered
   * Made-up sections like "Tips for Development" unless they exist in actual docs
   * Explanations of why something ISN'T relevant (just omit it)

   ## Integration

   * If .github/copilot-instructions.md already exists, suggest improvements rather than replacing it entirely
   * Incorporate important parts from README.md, CONTRIBUTING.md, or existing instruction files
   * Check for other AI assistant configs and incorporate their important parts:

     * Claude/OpenCode: CLAUDE.md
     * Cursor: .cursorrules, .cursor/rules/
     * Codex/Jules/OpenCode: AGENTS.md
     * Windsurf: .windsurfrules
     * Aider: CONVENTIONS.md, AIDER\_CONVENTIONS.md
     * Cline: .clinerules, .cline\_rules

   ## MCP Servers

   After creating the file, briefly ask if the user wants to configure any MCP servers relevant to the project type (e.g., Playwright for web projects). If none seem relevant, skip this section entirely - do not explain why MCP servers aren't needed.

   ## Finishing up

   End with a brief summary of what you created and ask if the user wants to adjust anything or add coverage for areas you may have missed. Do not list what you omitted.

   Start by exploring the repository structure.

2. Analyze this codebase and create a .github/copilot-instructions.md file to help future Copilot sessions work effectively in this repository.

   ## What to include

   1. **Build, test, and lint commands** - If they exist. Include how to run a single test, not just the full suite
   2. **High-level architecture** - Focus on the "big picture" that requires reading multiple files to understand
   3. **Key conventions** - Patterns specific to this codebase that aren't obvious from reading a single file

   ## What NOT to include

   * Generic development practices (e.g., "write unit tests", "use meaningful names")
   * Obvious instructions that any developer would know
   * Exhaustive file/directory listings that can be easily discovered
   * Made-up sections like "Tips for Development" unless they exist in actual docs
   * Explanations of why something ISN'T relevant (just omit it)

   ## Integration

   * If .github/copilot-instructions.md already exists, suggest improvements rather than replacing it entirely
   * Incorporate important parts from README.md, CONTRIBUTING.md, or existing instruction files
   * Check for other AI assistant configs and incorporate their important parts:

     * Claude/OpenCode: CLAUDE.md
     * Cursor: .cursorrules, .cursor/rules/
     * Codex/Jules/OpenCode: AGENTS.md
     * Windsurf: .windsurfrules
     * Aider: CONVENTIONS.md, AIDER\_CONVENTIONS.md
     * Cline: .clinerules, .cline\_rules

   ## MCP Servers

   After creating the file, briefly ask if the user wants to configure any MCP servers relevant to the project type (e.g., Playwright for web projects). If none seem relevant, skip this section entirely - do not explain why MCP servers aren't needed.

   ## Finishing up

   End with a brief summary of what you created and ask if the user wants to adjust anything or add coverage for areas you may have missed. Do not list what you omitted.

   Start by exploring the repository structure.

3. (/init) дав таку помилку: замість розгортання проєкту C++/CMake (створення CMakeLists.txt, вихідного коду hello, юніт-тесту BasicAddition, скриптів ci.sh/ci.bat та .gitignore) агент виконав дефолтну дію і створив лише .github/copilot-instructions.md.

   Проаналізуй причину і виправ ІНСТРУКЦІЇ в .github/prompts/init.prompt.md та .github/skills/project-scaffold/SKILL.md, щоб агент генерував правильно. Не прав згенеровані файли напряму.

4. Analyze this codebase and create a .github/copilot-instructions.md file to help future Copilot sessions work effectively in this repository.

   ## What to include

   1. **Build, test, and lint commands** - If they exist. Include how to run a single test, not just the full suite
   2. **High-level architecture** - Focus on the "big picture" that requires reading multiple files to understand
   3. **Key conventions** - Patterns specific to this codebase that aren't obvious from reading a single file

   ## What NOT to include

   * Generic development practices (e.g., "write unit tests", "use meaningful names")
   * Obvious instructions that any developer would know
   * Exhaustive file/directory listings that can be easily discovered
   * Made-up sections like "Tips for Development" unless they exist in actual docs
   * Explanations of why something ISN'T relevant (just omit it)

   ## Integration

   * If .github/copilot-instructions.md already exists, suggest improvements rather than replacing it entirely
   * Incorporate important parts from README.md, CONTRIBUTING.md, or existing instruction files
   * Check for other AI assistant configs and incorporate their important parts:

     * Claude/OpenCode: CLAUDE.md
     * Cursor: .cursorrules, .cursor/rules/
     * Codex/Jules/OpenCode: AGENTS.md
     * Windsurf: .windsurfrules
     * Aider: CONVENTIONS.md, AIDER\_CONVENTIONS.md
     * Cline: .clinerules, .cline\_rules

   ## MCP Servers

   After creating the file, briefly ask if the user wants to configure any MCP servers relevant to the project type (e.g., Playwright for web projects). If none seem relevant, skip this section entirely - do not explain why MCP servers aren't needed.

   ## Finishing up

   End with a brief summary of what you created and ask if the user wants to adjust anything or add coverage for areas you may have missed. Do not list what you omitted.

   Start by exploring the repository structure.

5. Запусти інструкцію з файлу .github/prompts/init.prompt.md. Створи структуру проєкту: CMakeLists.txt, src/hello.cpp, src/add.h, src/add.cpp, tests/test\_basic.cpp, ci.sh, ci.bat та .gitignore.
6. /check
7. (/check) дав таку помилку:

   1. Перевірка YAML завершилась помилкою через відсутність модуля Python PyYAML (ModuleNotFoundError: No module named 'yaml').
   2. Перевірка .gitignore впала через чутливість регулярного виразу до Windows переносів рядків (CRLF).

   Проаналізуй причину і виправ ІНСТРУКЦІЇ в .github/prompts/check.prompt.md або відповідному skill, щоб валідація YAML виконувалася без сторонніх бібліотек Python (або без жорсткої залежності від PyYAML), а перевірка .gitignore враховувала CRLF/LF. Не прав згенеровані файли проєкту напряму.

8. /check
9. У системі немає actionlint, Ruby або PyYAML, тому скрипт перевірки падає на валідації YAML.

   Онови .github/prompts/check.prompt.md: якщо actionlint, ruby та python-yaml недоступні в системі, не кидай throw помилку, а перевіряй файл .github/workflows/ci.yml на базову наявність обов'язкових рядків (name, on, jobs, runs-on, steps) або пропускай глибокий синтаксичний парсинг із попередженням. Зроби так, щоб /check завершувався зі статусом PASSED.

10. /check
11. (/check) впав на пункті 2 (Розділи skills): не в усіх трьох skills присутні точні заголовки другого рівня.

Будь ласка, онови такі файли:

1. .github/skills/project-scaffold/SKILL.md
2. .github/skills/build-and-test/SKILL.md
3. .github/skills/github-actions/SKILL.md

Переконайся, що в кожному з цих трьох файлів обов'язково присутні точні заголовки:

## Вхід

## Вихід

## Перевірки

Не чіпай файли коду проєкту. Після оновлення skills запусти /check повторно.

12. /check
13. Створи docs/usage.md: точні команди запуску агента (VS Code, Copilot Chat, агент build-engineer, /init, /check), локальної збірки (./ci.sh на Linux/macOS, ci.bat на Windows), запуску hello (./dist/hello або dist\\hello.exe), запуску тестів (ctest --test-dir build -C Release --output-on-failure).
14. Створи (або, якщо файл уже є, додай зверху над текстом те шо ти будеш писати) docs/ai-log.md: нумерований список усіх запитів, які я надсилав тобі в цьому чаті, від першого повідомлення до останнього, по порядку.
Кожен запит перепиши дослівно, як я його надсилав, нічого не скорочуй і не виправляй. Відповіді в файл не записуй. Без заголовків, вступу, висновку і пояснень, тільки список: 1., 2., 3. і так далі.
Включи всі мої повідомлення, зокрема повторні запити та запити на виправлення помилок. Поточний запит (про створення цього журналу) не включай. Якщо в якомусь запиті є паролі, токени чи ключі, заміни їх на \[приховано] і скажи мені про це.
15. Створи (або, якщо файл уже є, повністю перегенеруй) docs/ai-log.md: нумерований список усіх запитів, які я надсилав тобі в цьому чаті, від першого повідомлення до останнього, по порядку.
Кожен запит перепиши дослівно, як я його надсилав, нічого не скорочуй і не виправляй. Відповіді в файл не записуй. Без заголовків, вступу, висновку і пояснень, тільки список: 1., 2., 3. і так далі.
Включи всі мої повідомлення, зокрема повторні запити та запити на виправлення помилок. Поточний запит (про створення цього журналу) не включай. Якщо в якомусь запиті є паролі, токени чи ключі, заміни їх на \[приховано] і скажи мені про це.

