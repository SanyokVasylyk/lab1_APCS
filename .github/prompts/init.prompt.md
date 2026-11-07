---
description: "Оркестратор: послідовно підготувати, зібрати та перевірити Rust-проєкт hello через усі команди build-engineer."
agent: build-engineer
---

# 1. Призначення

Виконай команду `init`: послідовно запусти `git-init`, `create-project`,
`create-build`, `create-actions`, `check` і сформуй підсумковий звіт про кожен
крок. Не приховуй помилок і не вважай роботу успішною без `check`.

# 2. Передумови

Перевір усе до початку роботи. Якщо щось не виконано, зупинися, назви причину
й нічого не створюй.

- Git встановлено (`git --version`), Cargo встановлено (`cargo --version`).
- Поточна гілка не `master` і не `develop` (`git branch --show-current`);
  рекомендований формат `feature/...`.
- Гілка створена від `develop`: `git merge-base --is-ancestor develop HEAD`
  завершується з кодом `0`.
- Існують `.github/agents/build-engineer.agent.md`, три файли
  `.github/skills/*/SKILL.md` і шість файлів `.github/prompts/*.prompt.md`.

# 3. Дії

Виконуй строго по черзі; після кожного кроку перевір його результат і лише
тоді переходь до наступного.

1. `git-init`: підготуй `.gitignore` і `.gitattributes`, передай стан далі.
2. `create-project`: створи відсутню структуру проєкту, передай стан
   `Cargo.toml`, `src/main.rs`, `src/lib.rs`.
3. `create-build`: створи або перевір тест і скрипти, передай стан
   `tests/basic_addition.rs`, `ci.sh`, `ci.bat`.
4. `create-actions`: створи або перевір workflow, передай стан `ci.yml`.
5. `check`: виконай повну read-only перевірку всіх результатів.

# 4. Очікувані файли

Результат усіх команд: `.gitignore`, `.gitattributes`, `Cargo.toml`, `src/`,
`tests/basic_addition.rs`, `ci.sh`, `ci.bat`, `.github/workflows/ci.yml`.
Коміти й push `init` не виконує.

# 5. Команди перевірки

Підсумкова перевірка це `check`. Успіх фіксується лише при `PASS` за всіма
його пунктами.

# 6. Повідомлення про помилку

При першій помилці зупинися й виведи: назву кроку, причину, перелік файлів,
змінених до цього моменту, пропозицію виправлення. До наступних кроків не
переходь.

# 7. Ідемпотентність і звіт

Повторний запуск не руйнує проєкт: кожна команда пропускає вже коректні
файли. У кінці виведи звіт у форматі:

```text
git-init: PASS/FAIL
create-project: PASS/FAIL
create-build: PASS/FAIL
create-actions: PASS/FAIL
check: PASS/FAIL
Загальний результат: PASS/FAIL
```
