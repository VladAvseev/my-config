# Visual Studio Code

Пользовательские настройки VS Code: эргономика редактора, минималистичный интерфейс, тема Darcula,
форматирование Prettier, подсветка, терминал, Copilot и правила для файлов проекта.

## Файлы

| Файл | Целевой путь | Назначение |
| --- | --- | --- |
| `settings.json` | `~/.config/Code/User/settings.json` | пользовательские настройки (JSONC) |

## Что настраивает

- Редактор: табы по 2, `insertSpaces: false`, плавная прокрутка, миникарта выключена, перенос строк
  на 100 колонок, лигатуры, шрифт JetBrains Mono 14/18.
- Интерфейс: минимум лишних элементов (скрытый горизонтальный скроллбар и status bar, без command
  center и glyph margin), тема Darcula, масштаб окна 1.
- Подсветка: курсив для комментариев, ключевых слов и типов через `editor.tokenColorCustomizations`.
- Терминал: шрифт 15, курсор-линия, sticky scroll выключен.
- Файлы: скрыты `.next`, `.nuxt`, `.expo`, `.idea`, `coverage`; подтверждения удаления и drag-and-drop
  выключены.
- Форматирование: Prettier по умолчанию, формат при сохранении, без точек с запятой, табы, одинарные
  кавычки, ширина 80, без trailing comma.
- Emmet для Blade, React и Svelte; автоформатирование Go через `golang.go`.
- Вкладки: лимит 5 на группу, компактная высота, кастомные подписи для Next.js App Router.
- Git: smart commit, без открытия родительских репозиториев.
- Copilot и чат: базовые настройки, если расширение доступно.
- Телеметрия отключена.

## Требования

- VS Code 1.143.1 (проверено; сборка `visual-studio-code-bin`).
- Шрифт JetBrains Mono (лигатуры включены).
- Расширения:

| Расширение | Зачем |
| --- | --- |
| `esbenp.prettier-vscode` | форматирование и настройки `prettier.*` |
| `dbaeumer.vscode-eslint` | подсветка ошибок ESLint |
| `golang.go` | форматирование Go |
| `rokoroku.vscode-theme-darcula` | тема `Darcula` |

## Установка

### Linux (универсально)

Возьмите пакет на <https://code.visualstudio.com/download>:

```bash
# Debian / Ubuntu
sudo apt install ./code_*.deb

# Fedora / RHEL
sudo rpm --install code-*.rpm

# snap
sudo snap install code --classic
```

Либо распакуйте tar.gz и запускайте `./code`.

Шрифт: JetBrains Mono с <https://www.jetbrains.com/lp/mono/> или Nerd Font-вариант с
<https://www.nerdfonts.com/fonts>. Установите в `~/.local/share/fonts` и выполните `fc-cache -fv`.

### Arch / Omarchy

```bash
# сборка Microsoft (как на этой машине)
yay -S visual-studio-code-bin

# свободная сборка из репозитория
sudo pacman -S code

sudo pacman -S ttf-jetbrains-mono-nerd-basic
```

## Применение

Команды ниже выполняются из папки `vscode/` этого репозитория.

1. Сохраните текущие настройки:

   ```bash
   test -f ~/.config/Code/User/settings.json && \
     cp ~/.config/Code/User/settings.json \
        ~/.config/Code/User/settings.json.bak.$(date +%s)
   ```

2. Скопируйте конфиг:

   ```bash
   mkdir -p ~/.config/Code/User
   cp settings.json ~/.config/Code/User/settings.json
   ```

3. Установите расширения:

   ```bash
   code --install-extension esbenp.prettier-vscode
   code --install-extension dbaeumer.vscode-eslint
   code --install-extension golang.go
   code --install-extension rokoroku.vscode-theme-darcula
   ```

4. Перезагрузите окно: `Ctrl+Shift+P` → **Developer: Reload Window**. Полный перезапуск тоже подойдёт.

## Проверка

- `code --version` → `1.143.1`.
- `code --list-extensions` → четыре расширения из таблицы выше.
- Открытая тема — Darcula, status bar скрыт, миникарта выключена.
- Сохранение файла запускает Prettier (на файле JS/TS).
- В Go-файле форматирование идёт через `golang.go`.

## Откат

```bash
mv ~/.config/Code/User/settings.json.bak.<timestamp> ~/.config/Code/User/settings.json
```

Список бэкапов: `ls -t ~/.config/Code/User/settings.json.bak.*`.

## Заметки

- `settings.json` — JSONC: комментарии и висячие запятые допустимы, редактор их сохраняет.
- `editor.insertSpaces: false` означает табы, несмотря на `tabSize: 2`.
- Настройки `prettier.*` работают только с расширением Prettier; без него форматирование при
  сохранении не сработает.
- `workbench.colorTheme: "Darcula"` требует `rokoroku.vscode-theme-darcula`.
- Локальное расширение `omarchy-theme` (тема Omarchy) лежит в `~/.vscode/extensions/omarchy-theme`,
  ставится вручную и этим конфигом не используется — активна тема Darcula.
- Настройки Copilot применяются, если Copilot доступен в вашей сборке VS Code.
- `keybindings.json` в этом репозитории нет: горячие клавиши остаются стандартными.
- Для VS Code-форков (VSCodium и т. п.) путь другой: `~/.config/VSCodium/User/settings.json`.
