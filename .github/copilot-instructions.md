# Copilot instructions

## Project overview

This repository combines a small C++17 example project with a Copilot build-engineer workflow. The C++ build and application behavior are defined by `CMakeLists.txt`; the `.github/agents/`, `.github/skills/`, and `.github/prompts/` files define how Copilot scaffolds, builds, validates, and configures CI for the project. `/init` runs the stages in order: Git setup, project scaffold, build/tests, GitHub Actions, then read-only `/check`.

The application target is `hello`, linked to the `add_lib` library built from `src/add.cpp`. The current CMake target uses `src/hello.cpp`; `src/main.cpp` is also present and required by the scaffold/check instructions, but is not currently compiled by CMake. Treat the source list in `CMakeLists.txt` as authoritative and keep the prompts/docs consistent if changing the entry point.

GoogleTest is brought in through CMake `FetchContent`; `tests/test_basic.cpp` registers `BasicAddition.AddsTwoInts` with CTest. The platform CI scripts configure, build, test, and copy the executable to `dist/`; `.github/workflows/ci.yml` runs `ci.sh` on Linux/macOS and `ci.bat` on Windows, then uploads the artifact.

## Build and test

Run from the repository root:

```sh
cmake -S . -B build
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

Run just the addition test:

```sh
ctest --test-dir build -C Release --output-on-failure -R BasicAddition
```

The discovered full test name is `BasicAddition.AddsTwoInts`. On Windows, the executable is typically `build/Release/hello.exe`; on single-configuration Unix generators it is typically `build/hello`.

Run the local CI script from the repository root:

- Linux/macOS: `./ci.sh`
- Windows: `ci.bat`

There is no configured lint command in the repository. CI-related validation is defined in `.github/prompts/check.prompt.md`; its YAML check uses an installed parser when available and otherwise verifies the required workflow structure and script-only `run` steps.

## Repository-specific conventions

- The expected library and executable targets are named `add_lib` and `hello`; retain C++17 and the public `src/` include directory for `add_lib`.
- The GoogleTest case suite is named `BasicAddition`; keep it discoverable through `gtest_discover_tests` so CTest can run it by the `BasicAddition` filter.
- Keep generated build products in `build/` and CI artifacts in `dist/`; both are ignored by Git.
- Workflow `run` steps should invoke only the platform CI scripts, not inline CMake or CTest commands.
- `ci.sh` must retain its executable bit in Git. For script changes, verify the indexed mode as well as the script behavior.
- The prompts and skills are operational instructions, not just documentation: preserve their ordered workflow, read existing target files before editing, avoid overwriting conflicting project files, and report only checks that actually ran.
