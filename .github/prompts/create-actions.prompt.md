---
description: "Створити CI workflow GitHub Actions для Windows, Linux і macOS за допомогою skill github-actions."
agent: build-engineer
---

# 1. Призначення

Виконай команду `create-actions`: використай skill `github-actions`, щоб
створити `.github/workflows/ci.yml`, який лише запускає `ci.sh` і `ci.bat`.

# 2. Передумови

- У корені є `ci.sh` і `ci.bat` (результат `create-build`).
- Існує `.github/skills/github-actions/SKILL.md`; прочитай його перед роботою.

# 3. Дії

1. Прочитай skill `github-actions`.
2. Якщо `.github/workflows/ci.yml` існує й проходить усі перевірки з розділу 7
   skill, пропусти створення.
3. Інакше створи або онови лише відсутні частини файлу.
4. Виконай перевірки з розділу 7 skill і покажи результат.

# 4. Очікувані файли

```text
.github/workflows/ci.yml
```

# 5. Команди перевірки

- YAML валідний (відступи пробілами, без табуляцій).
- Містить `ubuntu-latest`, `windows-latest`, `macos-latest`.
- Містить `bash ci.sh` і `ci.bat` із `shell: cmd`, не містить `cargo` і
  секретів.
- Містить `actions/upload-artifact@v4` зі шляхом `build/`.

# 6. Повідомлення про помилку

Якщо `ci.sh` або `ci.bat` відсутні чи YAML невалідний, зупинися, назви крок і
причину, нічого не видаляй. Якщо бракує скриптів, запропонуй спочатку
виконати `create-build`.

# 7. Ідемпотентність

Повний коректний `ci.yml` пропускається без змін; тригери, job і кроки не
дублюються.
