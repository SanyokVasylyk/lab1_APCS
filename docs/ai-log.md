# Журнал взаємодії з AI

Інструмент: GitHub Copilot (VS Code, план Copilot Student), агент `build-engineer`.

## Записи

| № | Запит до Copilot |
|---|---|
| 1 | `/init` (запущено вбудовану команду VS Code, яка створила copilot-instructions.md; зміни скасовано) |
| 2 | `/init` (оркестратор build-engineer, гілка feature/hello-rust; результат: git-init, create-project, create-build, create-actions, check — усі PASS) |
| 3 | `/init` (повторний запуск для перевірки ідемпотентності; усі кроки PASS, `git status` чистий) |
| 4 | `/check` (після навмисного видалення macos-latest з ci.yml; результат FAIL у пункті h) |
| 5 | `/check` (після відновлення ci.yml через git restore; результат PASS) |

## Помилки та виправлення

| Етап | Помилка | Запит, що її виправив |
|---|---|---|
| Запуск `/init` | Вбудована команда `/init` VS Code перекрила prompt-команду і створила `copilot-instructions.md` | Зміни скасовано; оркестратор запущено повторно зі списку команд |
| Запуск команд | Prompt-команди `/git-init` та `/check` не відображалися в Copilot Chat | Виправлено в налаштуваннях VS Code: AI-функції для папки (`chat.disableAIFeatures`) знову ввімкнено |
| create-actions | Перевірка YAML впала: `python` відсутній у PATH; потім некоректний regex для керівних символів дав хибний FAIL і закрив термінал (`exit 1`) | Агент самостійно перейшов на іншу перевірку YAML і прибрав некоректний regex |
| check, пункт к) | Хибний FAIL: `docs/ai-log.md` нібито без розділу «Помилки та виправлення» (кодування кирилиці в PowerShell) | Агент повторив перевірку; файл не змінювався |
| Демонстрація check | Навмисно зламано ci.yml (прибрано macos-latest) | `/check` повернув FAIL без автоматичних виправлень; файл відновлено командою `git restore`, повторний `/check` дав PASS |