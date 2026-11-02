1. Analyze this codebase and create a .github/copilot-instructions.md file to help future Copilot sessions work effectively in this repository.

## What to include

1. **Build, test, and lint commands** - If they exist. Include how to run a single test, not just the full suite
2. **High-level architecture** - Focus on the "big picture" that requires reading multiple files to understand
3. **Key conventions** - Patterns specific to this codebase that aren't obvious from reading a single file

## What NOT to include

- Generic development practices (e.g., "write unit tests", "use meaningful names")
- Obvious instructions that any developer would know
- Exhaustive file/directory listings that can be easily discovered
- Made-up sections like "Tips for Development" unless they exist in actual docs
- Explanations of why something ISN'T relevant (just omit it)

## Integration

- If .github/copilot-instructions.md already exists, suggest improvements rather than replacing it entirely
- Incorporate important parts from README.md, CONTRIBUTING.md, or existing instruction files
- Check for other AI assistant configs and incorporate their important parts:
  - Claude/OpenCode: CLAUDE.md
  - Cursor: .cursorrules, .cursor/rules/
  - Codex/Jules/OpenCode: AGENTS.md
  - Windsurf: .windsurfrules
  - Aider: CONVENTIONS.md, AIDER_CONVENTIONS.md
  - Cline: .clinerules, .cline_rules

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

- Generic development practices (e.g., "write unit tests", "use meaningful names")
- Obvious instructions that any developer would know
- Exhaustive file/directory listings that can be easily discovered
- Made-up sections like "Tips for Development" unless they exist in actual docs
- Explanations of why something ISN'T relevant (just omit it)

## Integration

- If .github/copilot-instructions.md already exists, suggest improvements rather than replacing it entirely
- Incorporate important parts from README.md, CONTRIBUTING.md, or existing instruction files
- Check for other AI assistant configs and incorporate their important parts:
  - Claude/OpenCode: CLAUDE.md
  - Cursor: .cursorrules, .cursor/rules/
  - Codex/Jules/OpenCode: AGENTS.md
  - Windsurf: .windsurfrules
  - Aider: CONVENTIONS.md, AIDER_CONVENTIONS.md
  - Cline: .clinerules, .cline_rules

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

- Generic development practices (e.g., "write unit tests", "use meaningful names")
- Obvious instructions that any developer would know
- Exhaustive file/directory listings that can be easily discovered
- Made-up sections like "Tips for Development" unless they exist in actual docs
- Explanations of why something ISN'T relevant (just omit it)

## Integration

- If .github/copilot-instructions.md already exists, suggest improvements rather than replacing it entirely
- Incorporate important parts from README.md, CONTRIBUTING.md, or existing instruction files
- Check for other AI assistant configs and incorporate their important parts:
  - Claude/OpenCode: CLAUDE.md
  - Cursor: .cursorrules, .cursor/rules/
  - Codex/Jules/OpenCode: AGENTS.md
  - Windsurf: .windsurfrules
  - Aider: CONVENTIONS.md, AIDER_CONVENTIONS.md
  - Cline: .clinerules, .cline_rules

## MCP Servers

After creating the file, briefly ask if the user wants to configure any MCP servers relevant to the project type (e.g., Playwright for web projects). If none seem relevant, skip this section entirely - do not explain why MCP servers aren't needed.

## Finishing up

End with a brief summary of what you created and ask if the user wants to adjust anything or add coverage for areas you may have missed. Do not list what you omitted.

Start by exploring the repository structure.

5. Запусти інструкцію з файлу .github/prompts/init.prompt.md. Створи структуру проєкту: CMakeLists.txt, src/hello.cpp, src/add.h, src/add.cpp, tests/test_basic.cpp, ci.sh, ci.bat та .gitignore.

6. /check

7. (/check) дав таку помилку: 
1. Перевірка YAML завершилась помилкою через відсутність модуля Python PyYAML (ModuleNotFoundError: No module named 'yaml').
2. Перевірка .gitignore впала через чутливість регулярного виразу до Windows переносів рядків (CRLF).

Проаналізуй причину і виправ ІНСТРУКЦІЇ в .github/prompts/check.prompt.md або відповідному skill, щоб валідація YAML виконувалася без сторонніх бібліотек Python (або без жорсткої залежності від PyYAML), а перевірка .gitignore враховувала CRLF/LF. Не прав згенеровані файли проєкту напряму.

8. /check

9. У системі немає actionlint, Ruby або PyYAML, тому скрипт перевірки падає на валідації YAML. 

Онови .github/prompts/check.prompt.md: якщо actionlint, ruby та python-yaml недоступні в системі, не кидай throw помилку, а перевіряй файл .github/workflows/ci.yml на базову наявність обов'язкових рядків (name, on, jobs, runs-on, steps) або пропускай глибокий синтаксичний парсинг із попередженням. Зроби так, щоб /check завершувався зі статусом PASSED.

10. /check

11. /check

12. (/check) впав на пункті 2 (Розділи skills): не в усіх трьох skills присутні точні заголовки другого рівня.

Будь ласка, онови такі файли:
1. .github/skills/project-scaffold/SKILL.md
2. .github/skills/build-and-test/SKILL.md
3. .github/skills/github-actions/SKILL.md

Переконайся, що в кожному з цих трьох файлів обов'язково присутні точні заголовки:
## Вхід
## Вихід
## Перевірки

Не чіпай файли коду проєкту. Після оновлення skills запусти /check повторно.

13. /check

14. Створи docs/usage.md: точні команди запуску агента (VS Code, Copilot Chat, агент build-engineer, /init, /check), локальної збірки (./ci.sh на Linux/macOS, ci.bat на Windows), запуску hello (./dist/hello або dist\hello.exe), запуску тестів (ctest --test-dir build -C Release --output-on-failure).
