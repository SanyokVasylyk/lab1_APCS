---
name: build-and-test
description: "Створює юніт-тест BasicAddition і скрипти ci.sh та ci.bat, які збирають Rust-проєкт hello, запускають cargo test і копіюють виконуваний файл у build/. Застосовувати після створення базового проєкту."
---

# 1. Призначення і коли застосовувати

Skill описує систему складання і тестування для Rust-проєкту `hello`: тест,
скрипти збірки й копіювання виконуваного файлу в `build/`. Застосовуй після
`project-scaffold`.

# 2. Вхідні дані

- `Cargo.toml` з `name = "hello"`.
- `src/lib.rs` з `pub fn add(a: i32, b: i32) -> i32`.
- Робочий каталог: корінь репозиторію.

# 3. Що створює

- `tests/basic_addition.rs`:

```rust
#[allow(non_snake_case)]
#[test]
fn BasicAddition() {
    assert_eq!(hello::add(2, 3), 5);
}
```

- `ci.sh` (Linux, macOS):

```bash
#!/usr/bin/env bash
set -euo pipefail
cargo build --release
cargo test --release
mkdir -p build
cp target/release/hello build/hello
```

- `ci.bat` (Windows):

```bat
@echo off
cargo build --release
if errorlevel 1 exit /b 1
cargo test --release
if errorlevel 1 exit /b 1
if not exist build mkdir build
copy /Y target\release\hello.exe build\hello.exe >nul
if errorlevel 1 exit /b 1
```

Скрипти завершуються з ненульовим кодом при першій помилці.

# 4. Ідемпотентність

- Перед створенням перевіряй наявність файлу та його вміст.
- Якщо файл уже відповідає опису, не змінюй його; якщо відрізняється, покажи
  різницю й оновлюй лише потрібні рядки.
- Не дублюй тести, рядки скриптів чи налаштування.
- Не змінюй `src/` і `Cargo.toml`.

# 5. Приклад входу

```text
language: Rust, name: hello, build: release, test: BasicAddition
```

# 6. Очікуваний результат

```text
tests/basic_addition.rs
ci.sh
ci.bat
build/hello        (build/hello.exe на Windows)
```

# 7. Перевірки

1. Запусти `ci.bat` у Windows або `bash ci.sh` у Unix-подібному середовищі.
2. Код завершення дорівнює `0`.
3. Існує `build/hello` (`build/hello.exe` на Windows).
4. У виводі `cargo test` є рядок `test BasicAddition ... ok` і
   `test result: ok`.
5. `git status` не показує `target/` і `build/` як відстежувані.
6. Повідом результат кожної перевірки.

# 8. Типовий сценарій помилки

- Тест не знаходить крейт `hello`: перевір `name` у `Cargo.toml` і `[lib]`.
- Скрипт `ci.sh` падає з помилкою про символ `\r`: файл має закінчення рядків
  CRLF; потрібен `.gitattributes` (`*.sh text eol=lf`) і повторне збереження
  файлу з LF.
- Cargo не встановлено або тест не проходить: зупинися на цьому кроці, назви
  крок і точну причину, нічого не видаляй.
- Не вважай роботу успішною, доки причину не усунуто й перевірки не пройдено.
