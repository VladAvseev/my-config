# OpenCode

Конфиг OpenCode CLI: глобальные настройки сервера (`opencode.json`) и настройки терминального интерфейса
(`cli.json`). Плагин superpowers, MCP-сервер Exa и цвета агентов plan/build.

## Файлы

| Файл | Целевой путь | Назначение |
| --- | --- | --- |
| `opencode.json` | `~/.config/opencode/opencode.json` | глобальный конфиг: плагины, агенты, MCP |
| `cli.json` | `~/.config/opencode/cli.json` | настройки TUI: тема, вкладки, уведомления |

## Что настраивает

`opencode.json`:

- `autoupdate: false` — обновления только вручную через `opencode upgrade`.
- `plugins` — плагин `superpowers` из git-репозитория `obra/superpowers`.
- `agents.plan.color` и `agents.build.color` — цвета агентов в интерфейсе.
- `mcp.servers.exa` — удалённый MCP-сервер Exa с инструментами поиска и чтения страниц. Ключ
  подставляется из переменной окружения `EXA_API_KEY`, в файле его нет.

`cli.json`:

- `session.sidebar: hide` — скрытая боковая панель.
- `theme.name: system`, `theme.mode: dark` — тема и тёмный режим.
- `animations: true`, `cursor.style: default` — анимации включены, форма курсора берётся из терминала.
- `tabs.mode: on` — постоянная полоса вкладок сессий.
- `prompt.image_preview: false` — без превью изображений в промпте.
- `attention.notifications: true` — системные уведомления.

## Требования

- OpenCode 2.2.0 (проверено, ветка V2).
- `git` — для установки плагина superpowers.
- API-ключ Exa — для MCP-сервера `exa`.
- Node.js и npm — только если ставите через npm.

## Установка

### Linux (универсально)

```bash
# официальный установщик
curl -fsSL https://opencode.ai/v2/install | bash

# или npm
npm install -g @opencode/cli

# или mise (нужен mise 2026.10.9+)
mise use -g opencode
```

### Arch / Omarchy

```bash
yay -S opencode-beta
```

Подойдёт и npm/mise из блока выше. В Omarchy ставьте любым способом выше.

## Ключ Exa

Ключ не хранится в репозитории: в `opencode.json` стоит `{env:EXA_API_KEY}`. Если переменная не задана,
OpenCode подставит пустую строку и MCP-сервер не авторизуется.

Для zsh (текущая оболочка):

```bash
echo 'export EXA_API_KEY="ваш-ключ"' >> ~/.zshrc
source ~/.zshrc
printenv EXA_API_KEY
```

Для приложений, запускаемых не из терминала, можно положить переменную в `~/.config/environment.d/exa.conf`:

```ini
EXA_API_KEY=ваш-ключ
```

После этого нужен повторный вход в сессию.

## Применение

Команды ниже выполняются из папки `opencode/` этого репозитория.

1. Сохраните текущие конфиги:

   ```bash
   for f in opencode.json cli.json; do
     test -f ~/.config/opencode/$f && \
       cp ~/.config/opencode/$f ~/.config/opencode/$f.bak.$(date +%s)
   done
   ```

2. Скопируйте файлы из репозитория:

   ```bash
   mkdir -p ~/.config/opencode
   cp opencode.json cli.json ~/.config/opencode/
   ```

3. Задайте `EXA_API_KEY` (см. выше).

4. Запустите OpenCode:

   ```bash
   opencode
   ```

   Конфиг перечитывается автоматически при сохранении. Если TUI уже запущен, используйте `/reload`
   или `opencode reload`.

## Проверка

- `opencode --version` → `2.2.0`.
- `opencode debug paths config` → путь `~/.config/opencode`.
- `opencode mcp list` → в списке есть `exa`; при необходимости авторизуйтесь через `/mcps`.
- В TUI: скрытая боковая панель, вкладки сессий, тёмная тема, уведомления.

## Откат

```bash
mv ~/.config/opencode/opencode.json.bak.<timestamp> ~/.config/opencode/opencode.json
mv ~/.config/opencode/cli.json.bak.<timestamp> ~/.config/opencode/cli.json
```

Список бэкапов: `ls -t ~/.config/opencode/*.bak.*`.

## Заметки

- `service.json` в репозиторий не входит: там пароль фонового сервиса. OpenCode создаёт и хранит его
  сам, вручную редактировать не нужно.
- Глобальный `~/.config/opencode/AGENTS.md` — личные инструкции для агентов, к этому конфигу
  не относится и здесь не хранится.
- Плагин `superpowers` ставится из git при первом запуске. Нужны сеть и `git`; без них плагин
  не загрузится.
- При `autoupdate: false` обновляйтесь вручную: `opencode upgrade`.
- Если ключ Exa когда-либо попадал в git или публичный файл, отзовите его и выпустите новый.
