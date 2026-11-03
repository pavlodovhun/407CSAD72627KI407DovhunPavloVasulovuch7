@echo off
setlocal

set "ROOT_DIR=%~dp0"
if "%ROOT_DIR:~-1%"=="\" set "ROOT_DIR=%ROOT_DIR:~0,-1%"

if not exist "%ROOT_DIR%\build" (
    mkdir "%ROOT_DIR%\build"
    if errorlevel 1 exit /b 1
)
if not exist "%ROOT_DIR%\dist" (
    mkdir "%ROOT_DIR%\dist"
    if errorlevel 1 exit /b 1
)

cmake -S "%ROOT_DIR%" -B "%ROOT_DIR%\build" -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 exit /b %errorlevel%

cmake --build "%ROOT_DIR%\build" --config Release
if errorlevel 1 exit /b %errorlevel%

ctest --test-dir "%ROOT_DIR%\build" -C Release --output-on-failure
if errorlevel 1 exit /b %errorlevel%

if exist "%ROOT_DIR%\build\Release\hello.exe" (
    copy /Y "%ROOT_DIR%\build\Release\hello.exe" "%ROOT_DIR%\dist\hello.exe" > nul
    if errorlevel 1 exit /b 1
) else (
    echo Missing built hello executable at "%ROOT_DIR%\build\Release\hello.exe"
    exit /b 1
)
