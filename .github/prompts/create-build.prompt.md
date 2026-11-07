---
description: "Створити тест BasicAddition та скрипти ci.sh і ci.bat за допомогою skill build-and-test."
agent: build-engineer
---

# 1. Призначення

Виконай команду `create-build`: використай skill `build-and-test`, щоб створити
юніт-тест `BasicAddition` та скрипти збірки `ci.sh` і `ci.bat`.

# 2. Передумови

- `Cargo.toml` має `name = "hello"`, існує `src/lib.rs` з функцією `add`
  (результат `create-project`).
- Існує `.github/skills/build-and-test/SKILL.md`; прочитай його перед роботою.

# 3. Дії

1. Прочитай skill `build-and-test` і виконай його інструкції.
2. Створи або оновлюй лише відсутні файли: `tests/basic_addition.rs`, `ci.sh`,
   `ci.bat`. Наявні файли, що вже відповідають skill, не змінюй.
3. Запусти `ci.bat` у Windows або `bash ci.sh` у Unix-подібному середовищі.
4. Виконай перевірки з розділу 7 skill і покажи результат.

# 4. Очікувані файли

```text
tests/basic_addition.rs
ci.sh
ci.bat
build/hello   (build/hello.exe на Windows; не потрапляє в Git)
```

# 5. Команди перевірки

- `ci.bat` (Windows) або `bash ci.sh`: код завершення `0`.
- У виводі `cargo test` є `test BasicAddition ... ok`.
- Існує `build/hello` або `build/hello.exe`.

# 6. Повідомлення про помилку

Якщо збірка або тест не проходять, зупинися, назви крок, наведи релевантну
частину виводу, перелік змінених файлів. Нічого не видаляй.

# 7. Ідемпотентність

Повторний запуск не дублює тести й рядки скриптів, не перезаписує файли, що
вже відповідають вимогам.
