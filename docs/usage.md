# Інструкція з використання

## Запуск AI-агента

1. Відкрити репозиторій у VS Code з активним GitHub Copilot.
2. Перейти на робочу гілку, створену від `develop`:
   ```powershell
   git checkout develop
   git checkout -b feature/hello-rust
   ```
   Оркестратор не запускається з гілок `master` і `develop`.
3. Відкрити Copilot Chat, вибрати агента `build-engineer`.
4. Ввести `/init` і вибрати зі списку команду-оркестратор. Підтверджувати запити на виконання команд, переглядаючи їх.
5. Дочекатися підсумку: `git-init`, `create-project`, `create-build`, `create-actions`, `check` мають мати статус PASS.

Окремі команди: `/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check`.

## Локальна збірка і тестування

Windows:

```powershell
.\ci.bat
.\build\hello.exe
```

Linux та macOS:

```bash
bash ci.sh
./build/hello
```

Очікуваний результат: тест `BasicAddition` проходить, скрипт завершується з кодом 0, програма виводить `Hello, World!`.

Окремо тести: `cargo test`.

## Перевірка проєкту

Команда `/check` у Copilot Chat лише читає проєкт і виводить PASS/FAIL по кожному пункту, нічого не змінюючи.

## CI

Workflow `.github/workflows/ci.yml` запускається при push і pull_request до `develop` та `master` на ubuntu-latest, windows-latest і macos-latest. Виконувані файли зберігаються як артефакти `hello-<os>`.