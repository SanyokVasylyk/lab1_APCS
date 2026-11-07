---
name: github-actions
description: "Створює workflow .github/workflows/ci.yml для Rust-проєкту hello: одна job з matrix для Ubuntu, Windows і macOS, яка лише запускає ci.sh або ci.bat і зберігає build/ як артефакт. Застосовувати після створення скриптів збірки."
---

# 1. Призначення і коли застосовувати

Skill описує створення CI workflow GitHub Actions, що запускає наявні скрипти
`ci.sh` і `ci.bat` на трьох ОС. Застосовуй після `build-and-test`.

# 2. Вхідні дані

- `ci.sh` і `ci.bat` у корені репозиторію.
- Робочий каталог: корінь репозиторію.

# 3. Що створює

`.github/workflows/ci.yml`:

```yaml
name: Rust CI

on:
  push:
    branches: [develop, master]
  pull_request:
    branches: [develop, master]

jobs:
  ci:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - name: Run Unix CI script
        if: runner.os != 'Windows'
        run: bash ci.sh
      - name: Run Windows CI script
        if: runner.os == 'Windows'
        run: ci.bat
        shell: cmd
      - uses: actions/upload-artifact@v4
        with:
          name: hello-${{ matrix.os }}
          path: build/
```

Правила: workflow лише викликає скрипти й завантажує результат; прямих
викликів `cargo` у YAML немає; секретів, токенів і паролів немає.

# 4. Ідемпотентність

- Перед створенням перевіряй наявність `.github/workflows/ci.yml`.
- Якщо файл проходить усі перевірки з розділу 7, пропусти крок без змін.
- Якщо чогось бракує, оновлюй лише відсутні частини, не дублюй тригери, job
  чи кроки.

# 5. Приклад входу

```text
language: Rust, name: hello, scripts: ci.sh, ci.bat, workflow: GitHub Actions
```

# 6. Очікуваний результат

```text
.github/workflows/ci.yml
```

# 7. Перевірки

1. YAML валідний (відступи, відсутність табуляцій).
2. У matrix є `ubuntu-latest`, `windows-latest`, `macos-latest`.
3. Є виклики `bash ci.sh` і `ci.bat` з `shell: cmd` для Windows.
4. У файлі немає `cargo` і секретів.
5. Є `actions/upload-artifact@v4` зі шляхом `build/`.
6. Тригери `push` і `pull_request` стосуються `develop` і `master`.
7. Повідом результат кожної перевірки.

# 8. Типовий сценарій помилки

- `ci.sh` або `ci.bat` відсутні: зупинися, назви, чого бракує, і запропонуй
  спочатку виконати `create-build`.
- YAML невалідний або для Windows не вказано `shell: cmd`: зупинися, назви
  крок і причину, нічого не видаляй.
- Не вважай роботу успішною, доки причину не усунуто й перевірки не пройдено.
