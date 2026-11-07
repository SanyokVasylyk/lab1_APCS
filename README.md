# Лабораторна робота №1. Проєктування AI-агента для автоматизації розробки та CI/CD

- **Студент:** Василик Олександр Романович
- **Група:** КІ-403
- **Варіант:** 4 (Rust, Cargo, cargo test)
- **Репозиторій:** https://github.com/SanyokVasylyk/lab1_APCS

## Опис

Репозиторій містить AI-агента `build-engineer` для GitHub Copilot у VS Code.
Агент за допомогою skills і commands генерує мінімальний кросплатформний
проєкт Hello World мовою Rust, систему складання (Cargo), юніт-тест
`basic_addition` та CI workflow GitHub Actions для Windows, Linux і macOS.

## Гілки

| Гілка | Призначення |
|---|---|
| `develop` | AI-агент з інструкціями (manifest, skills, prompts), документація |
| `feature/...` | Результат запуску агента: проєкт, тести, скрипти збірки, CI |
| `master` | Фінальна версія після перевірки |

## Запуск агента

1. Відкрити репозиторій у VS Code з активним GitHub Copilot.
2. Відкрити Copilot Chat і вибрати агента `build-engineer`.
3. Виконати команду-оркестратор: `/init`

Окремі команди: `/git-init`, `/create-project`, `/create-build`,
`/create-actions`, `/check`.

Докладніше: [docs/usage.md](docs/usage.md). Архітектура агента:
[docs/architecture.md](docs/architecture.md).

## Запуск зібраного проєкту

- Windows: `.\ci.bat`, потім `.\build\hello.exe`.
- Linux та macOS: `bash ci.sh`, потім `./build/hello`.

Детальніше: [docs/usage.md](docs/usage.md).