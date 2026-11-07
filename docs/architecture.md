# Архітектура AI-агента build-engineer

## 1. Задача, яку вирішує агент

Ручне створення навіть найпростішого проєкту потребує багатьох повторюваних
кроків: структура каталогів, конфігурація збірки, тести, скрипти, CI. Агент
`build-engineer` перетворює ці кроки на відтворюваний процес із перевірками:
запуск `/init` у чистій робочій гілці дає працюючий проєкт Rust, який
збирається й тестується локально та в GitHub Actions на трьох ОС.
Замість одного загального запиту «зроби проєкт» агент має роль, обмеження,
окремі skills, явні commands та оркестратор, який зупиняється на першій
помилці й не вважає роботу успішною без перевірки.

## 2. Складові агента

| Компонент | Файл | Роль |
|---|---|---|
| Agent manifest | `.github/agents/build-engineer.agent.md` | Роль, область відповідальності, правила роботи з файлами, заборони, критерії завершення |
| Skill | `.github/skills/project-scaffold/SKILL.md` | Мінімальний Hello World, `Cargo.toml`, `src/main.rs`, `src/lib.rs`, README, структура каталогів, `.gitignore` |
| Skill | `.github/skills/build-and-test/SKILL.md` | Функція `add`, тест `BasicAddition`, скрипти `ci.sh` і `ci.bat`, копіювання виконуваного файлу в `build/` |
| Skill | `.github/skills/github-actions/SKILL.md` | `.github/workflows/ci.yml` з matrix Windows / Linux / macOS |
| Command | `.github/prompts/git-init.prompt.md` | Перевірка репозиторію, `.gitignore`, стан Git |
| Command | `.github/prompts/create-project.prompt.md` | Виклик skill `project-scaffold` |
| Command | `.github/prompts/create-build.prompt.md` | Виклик skill `build-and-test` |
| Command | `.github/prompts/create-actions.prompt.md` | Виклик skill `github-actions` |
| Command | `.github/prompts/check.prompt.md` | Перевірка без змін: структура, збірка, тести, YAML, Git |
| Orchestrator | `.github/prompts/init.prompt.md` | Послідовний запуск усіх команд зі звітом |

## 3. Відповідність файлів ролям (GitHub Copilot у VS Code)

| Роль за методичкою | Формат у VS Code / Copilot |
|---|---|
| Agent manifest | `*.agent.md` у `.github/agents/` |
| Skill | `SKILL.md` у `.github/skills/<name>/` |
| Command | `*.prompt.md` у `.github/prompts/`, виклик як `/<name>` у Copilot Chat |
| Система складання | `Cargo.toml` замість `CMakeLists.txt` |
| Каталог складання `build/` | Cargo збирає в `target/`; скрипти `ci.sh` / `ci.bat` копіюють виконуваний файл у `build/`; обидва каталоги в `.gitignore` |
| Тест `BasicAddition` | функція `BasicAddition` у `tests/basic_addition.rs` (`#[allow(non_snake_case)]`) |
| Виконуваний файл `hello` | `build/hello` (Linux, macOS), `build/hello.exe` (Windows) |
| Журнал взаємодії з AI | `docs/ai-log.md` |

## 4. Гілки

| Гілка | Вміст |
|---|---|
| `develop` | Лише агент (manifest, skills, prompts) і документація |
| `feature/hello-rust` | Створена від `develop`; містить результат запуску `/init`: проєкт, тести, скрипти, CI |
| `master` | Фінальна версія після перевірки |

Фінальний pull request `lab1/finish` іде з `feature/hello-rust` у `develop`.

## 5. Дані між етапами

| Етап | Вхід | Вихід | Передається далі |
|---|---|---|---|
| git-init | стан репозиторію | `.gitignore` (`target/`, `build/`), звіт `git status` | перелік ігнорованих шляхів |
| create-project | мова (Rust), назва проєкту `hello` | `Cargo.toml`, `src/main.rs`, `src/lib.rs`, README | назва пакета, ім'я бінарника `hello` |
| create-build | `Cargo.toml`, `src/lib.rs` | `tests/basic_addition.rs`, `ci.sh`, `ci.bat` | команди збірки й тестів |
| create-actions | `ci.sh`, `ci.bat` | `.github/workflows/ci.yml` | шлях до workflow |
| check | усі артефакти | звіт PASS / FAIL по кожній перевірці | підсумок оркестратору |

Дані передаються через стан репозиторію: кожен наступний крок читає файли,
створені попередніми.

## 6. Обробка помилок оркестратором

- Перед запуском перевіряються передумови: Git-репозиторій, наявність `cargo`,
  наявність файлів агента, робоча гілка (не `master` і не `develop`).
- Команди виконуються строго по черзі: `git-init`, `create-project`,
  `create-build`, `create-actions`, `check`.
- Якщо будь-яка команда завершилась помилкою, оркестратор **зупиняється**,
  виводить назву кроку, причину та файли, які вже були змінені, і не
  переходить до наступного кроку.
- Успіх фіксується лише коли `check` повернув PASS за всіма пунктами.
- Повторний запуск ідемпотентний: наявні файли перевіряються, а не
  перезаписуються; конфігурації не дублюються.

## 7. Безпека

Агент не видаляє файли, не виконує `git push --force`, не переписує історію
Git, не змінює захист гілок і не працює із секретами. Тимчасові каталоги
(`target/`, `build/`) не потрапляють під Git-контроль. Деталі в manifest
агента.