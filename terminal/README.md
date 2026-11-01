# Терминал: foot + zsh

Связка эмулятора терминала и интерактивного шелла: foot отвечает за отображение, zsh — за оболочку,
историю, completion и промпт. Конфиги применяются независимо, но инструкция собрана в один сценарий
«от установки до проверки».

## Файлы

| Файл | Целевой путь | Назначение |
| --- | --- | --- |
| `foot.ini` | `~/.config/foot/foot.ini` | конфиг эмулятора foot |
| `.zshrc` | `~/.zshrc` | конфиг zsh |
| `themes/tea.zsh-theme` | `~/.config/zsh/themes/tea.zsh-theme` | fallback-промпт Tea, если нет темы Omarchy |

## Что настраивает

### foot

- `font=JetBrainsMono Nerd Font:size=11` — шрифт с иконками Nerd Font.
- `pad=14x14` — внутренние отступы окна.
- `initial-window-mode=windowed` — обычное окно, не maximized/fullscreen.
- `workers=0` — отключает многопоточный рендеринг (0 = один поток; по умолчанию foot берёт все
  логические CPU).
- `scrollback.lines=10000`, `multiplier=7.0` — история и скорость прокрутки колесом.
- `cursor.style=beam`, `blink=no`, `beam-thickness=1px` — статичный курсор-луч.
- `key-bindings` — копирование и вставка на `Ctrl+Shift+C/V` и `Ctrl+Insert`/`Shift+Insert`;
  `primary-paste=none` отключает вставку средней кнопкой мыши.
- `text-bindings` — `Shift+Return` отправляется как `ESC[13;2u`, `Alt+Shift+Return` как `ESC[13;4u`
  (CSI-u). Это нужно, чтобы TUI, включая OpenCode, отличали Shift+Enter от Enter.
- `include=~/.local/state/omarchy/current/theme/foot.ini` — цвета текущей темы Omarchy.
- `[colors-dark] alpha=0.5 blur=yes` — полупрозрачный фон с размытием композитора.

### zsh

- История: `~/.zsh_history`, `HISTSIZE=10000`, `SAVEHIST=10000`, `extended_history`,
  `share_history`, игнорирование дублей и команд с ведущим пробелом.
- Completion: `compinit` с кешем `~/.cache/zsh/zcompdump`, `menu select`, регистронезависимый
  `matcher-list`, цвета списков из `LS_COLORS` плюс своя подсветка выбранного пункта.
- `LS_COLORS`: убраны нечитаемые плашки для sticky/other-writable каталогов, `di=01;34`.
- Клавиатура: emacs-режим, Home/End/Delete, переход по словам на `Ctrl+Left`/`Ctrl+Right`.
- `auto_cd` — переход в каталог простым вводом имени.
- Алиасы `ls` и `grep` с `--color=auto`.
- Промпт: тема Omarchy `omarchy-zsh-theme.zsh`, fallback `tea.zsh-theme`. Две строки, powerline,
  имя пользователя, каталог, git-ветка, код возврата последней команды.
- Плагины: `zsh-autosuggestions` и `zsh-syntax-highlighting`. Второй загружается последним.
- `PATH`: добавлен `~/.local/bin`.

## Требования

- foot 1.28.0 и zsh 5.9.2 (проверено).
- Wayland-композитор. Размытие работает только там, где поддерживается blur (в Hyprland и Omarchy
  он включён).
- JetBrainsMono Nerd Font — нужен и foot, и промпту zsh (powerline-глифы).
- Терминал с truecolor.
- Пакеты `zsh-autosuggestions` и `zsh-syntax-highlighting`.
- `git` — для ветки в промпте.
- Omarchy — только для `include` темы foot и генерации zsh-темы. Без него работают fallback-тема
  и остальной конфиг.

## Установка

### Linux (универсально)

```bash
# Debian / Ubuntu
sudo apt install foot zsh zsh-autosuggestions zsh-syntax-highlighting

# Fedora
sudo dnf install foot zsh zsh-autosuggestions zsh-syntax-highlighting

# openSUSE
sudo zypper install foot zsh zsh-autosuggestions zsh-syntax-highlighting
```

Если пакетов плагинов нет в репозитории дистрибутива, склонируйте их локально:

```bash
mkdir -p ~/.config/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.config/zsh/plugins/zsh-syntax-highlighting
```

`.zshrc` ищет плагины в `/usr/share/zsh/plugins/<name>`, `/usr/share/<name>` и
`~/.config/zsh/plugins/<name>`, поэтому править пути не нужно.

Шрифт: скачайте JetBrainsMono Nerd Font с <https://www.nerdfonts.com/fonts>, распакуйте в
`~/.local/share/fonts` и обновите кеш:

```bash
fc-cache -fv
fc-list | grep -i "JetBrainsMono Nerd Font"
```

Сделайте zsh шеллом по умолчанию:

```bash
command -v zsh
chsh -s "$(command -v zsh)"
```

Путь `zsh` должен быть в `/etc/shells`; обычно пакет добавляет его сам. После `chsh` нужен повторный
вход в сессию.

### Arch / Omarchy

```bash
sudo pacman -S foot zsh zsh-autosuggestions zsh-syntax-highlighting \
  ttf-jetbrains-mono-nerd-basic
```

В Omarchy foot уже установлен. Проверьте шелл и шрифт:

```bash
getent passwd "$USER" | cut -d: -f7
fc-list | grep -i "JetBrainsMono"
```

Если шелл не `/usr/bin/zsh`, выполните `chsh -s /usr/bin/zsh` и войдите заново. Если нет шрифта —
`sudo pacman -S ttf-jetbrains-mono-nerd-basic`.

## Применение

Команды ниже выполняются из папки `terminal/` этого репозитория.

### 1. foot

1. Сохраните текущий конфиг:

   ```bash
   test -f ~/.config/foot/foot.ini && \
     cp ~/.config/foot/foot.ini ~/.config/foot/foot.ini.bak.$(date +%s)
   ```

2. Скопируйте конфиг из репозитория:

   ```bash
   mkdir -p ~/.config/foot
   cp foot.ini ~/.config/foot/foot.ini
   ```

3. Проверьте, что файл темы существует:

   ```bash
   ls ~/.local/state/omarchy/current/theme/foot.ini
   ```

   Если файла нет, закомментируйте строку `include=` в `foot.ini` или укажите свой файл с цветами.

4. Проверьте конфиг:

   ```bash
   foot --check-config; echo $?
   ```

   Код 0 — всё в порядке.

5. Запустите новый терминал:

   ```bash
   foot
   ```

   Уже открытые окна foot конфиг не перечитывают.

### 2. zsh

1. Сохраните текущие файлы:

   ```bash
   test -f ~/.zshrc && cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
   test -f ~/.config/zsh/themes/tea.zsh-theme && \
     cp ~/.config/zsh/themes/tea.zsh-theme \
        ~/.config/zsh/themes/tea.zsh-theme.bak.$(date +%s)
   ```

2. Скопируйте конфиг и тему из репозитория:

   ```bash
   mkdir -p ~/.config/zsh/themes
   cp .zshrc ~/.zshrc
   cp themes/tea.zsh-theme ~/.config/zsh/themes/tea.zsh-theme
   ```

3. Перезапустите шелл:

   ```bash
   exec zsh
   ```

   Или просто откройте новый терминал.

## Проверка

### foot

- `foot --version` → `1.28.0`.
- `foot --check-config` → код возврата 0.
- Визуально: JetBrains Mono, отступы 14 px, курсор-луч без мигания, полупрозрачный фон с blur.
- `Ctrl+Shift+C` и `Ctrl+Shift+V` копируют и вставляют; средняя кнопка мыши не вставляет.
- В OpenCode `Shift+Enter` переносит строку, а не отправляет промпт.

### zsh

- `zsh --version` → `5.9.2`.
- `getent passwd "$USER" | cut -d: -f7` → `/usr/bin/zsh`.
- `zsh -n ~/.zshrc` — без вывода и без ошибок.
- Промпт двухстрочный: пользователь, каталог, git-ветка, строка с `❯`. При ошибке последней
  команды стрелка краснеет, справа появляется код возврата.
- Начните вводить команду из истории — появится автоподсказка; `→` принимает её.
- Неверная команда подсвечивается красным, корректная — зелёным (`zsh-syntax-highlighting`).
- `Ctrl+Right` и `Ctrl+Left` двигают курсор по словам.
- История сохраняется между сессиями.
- `printenv PATH` содержит `~/.local/bin`.

## Откат

foot:

```bash
mv ~/.config/foot/foot.ini.bak.<timestamp> ~/.config/foot/foot.ini
```

zsh:

```bash
mv ~/.zshrc.bak.<timestamp> ~/.zshrc
mv ~/.config/zsh/themes/tea.zsh-theme.bak.<timestamp> \
   ~/.config/zsh/themes/tea.zsh-theme
```

Список бэкапов:

```bash
ls -t ~/.config/foot/foot.ini.bak.* ~/.zshrc.bak.* ~/.config/zsh/themes/*.bak.*
```

## Заметки

- `zsh-syntax-highlighting` должен загружаться последним, иначе подсветка работает нестабильно.
- Файл `~/.local/state/omarchy/current/theme/omarchy-zsh-theme.zsh` генерируется Omarchy при смене
  темы. Если его нет, `.zshrc` подхватывает статичную `tea.zsh-theme`. Не редактируйте
  сгенерированный файл вручную.
- `~/.oh-my-zsh` больше не используется: `.zshrc` его не подключает. Каталог можно удалить, если
  ничего на него не ссылается.
- starship установлен и есть `~/.config/starship.toml`, но в `.zshrc` не подключён — промпт рисует
  Tea. Если нужен starship, добавьте `eval "$(starship init zsh)"` и уберите блок промпта.
- zoxide, fzf, eza, bat, fd, ripgrep и tmux установлены, но в `.zshrc` не инициализированы. Это
  отдельные утилиты, в конфиг терминала не входят.
- `.zshenv`, `.zprofile` и `.zlogin` не используются: вся настройка в одном `.zshrc`.
- Если `include` указывает на несуществующий файл, foot пишет ошибку в stderr, но при обычном
  запуске продолжает работу с остальными настройками. `foot --check-config` в этом случае
  завершается с ошибкой.
- `alpha=0.5` делает фон полупрозрачным, а `blur=yes` просит композитор размыть то, что под ним.
  Без поддержки blur останется просто прозрачность.
- Если шрифт не установлен, foot подставит fallback, а промпт zsh покажет вместо powerline-глифов
  квадраты.
- Блок загрузки плагинов в репозитории отличается от живого `~/.zshrc` только поиском путей:
  Arch, Debian/Ubuntu, Fedora и `~/.config/zsh/plugins`. Поведение то же.
