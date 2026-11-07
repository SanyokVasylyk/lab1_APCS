@echo off
cargo build --release
if errorlevel 1 exit /b 1
cargo test --release
if errorlevel 1 exit /b 1
if not exist build mkdir build
copy /Y target\release\hello.exe build\hello.exe >nul
if errorlevel 1 exit /b 1