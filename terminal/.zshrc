# ~/.zshrc — чистый zsh после удаления oh-my-zsh (миграция 2026-10-20).
# Промпт: дизайн темы "Tea", но цвета берутся из активной Omarchy-темы
# (рендерится в ~/.local/state/omarchy/current/theme/omarchy-zsh-theme.zsh,
# Tea — вербатим-копия в папке темы; fallback ~/.config/zsh/themes/tea.zsh-theme)

# --- История (те же пути и правила, что давал oh-my-zsh lib/history.zsh) ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify share_history

# --- Цвета ls + дополнения ---
# Каталоги со sticky/other-writable правами (напр. /tmp) по умолчанию получают
# чёрный текст на зелёной плашке (tw=30;42 / ow=34;43 / st=37;44) — нечитаемо
# в палитре Tea: подложку убираем, оставляя различие цветом текста; остальная
# раскраска — стандартная. di=01;34 — каталоги как у ls (жирный синий).
# ВАЖНО: GNU ls парсит LS_COLORS строго — незнакомый ключ делает переменную
# целиком невалидной (ls: unparsable value), поэтому дополнительные ключи
# zsh/complist живут только в list-colors ниже, а не в LS_COLORS.
export LS_COLORS="${LS_COLORS:+${LS_COLORS}:}tw=32:ow=34:st=37:di=01;34"

# --- Completion (аналог oh-my-zsh lib/completion.zsh, с кэшем) ---
mkdir -p -- "$HOME/.cache/zsh"
autoload -Uz compinit && compinit -d "$HOME/.cache/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'm:|=*' 'l:|=* r:|=*'
# Цвета списков дополнения = LS_COLORS (как у ls) + расширение zsh/complist:
# ma=48;2;58;75;69;38;2;228;236;233 — подсветка выбранного в menu-select
# элемента: фон — selection-цвет Tea (#3A4B45), текст — bright_foreground
# (#E4ECE9). Заменяет дефолт ma=7 (standout-инверсию), которая поверх зелёных
# каталогов из палитры complist давала нечитаемую светлую плашку
# (см. zshmodules(1): zsh/complist, Colored completion listings / Menu selection).
zstyle ':completion:*' list-colors "${(j.:.)${(s.:.)LS_COLORS}}:ma=48;2;58;75;69;38;2;228;236;233"

# --- Клавиатура ---
bindkey -e
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char        # Delete
bindkey '^[[1;5C' forward-word     # Ctrl+Right
bindkey '^[[1;5D' backward-word    # Ctrl+Left

# --- Поведение каталогов ---
setopt auto_cd  # переход в каталог простым вводом его имени

# --- Алиасы (ровно те, что шеллу давал oh-my-zsh) ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- Промпт: перекрашивается из активной Omarchy-темы.
# Файл рендерится из ~/.config/omarchy/themed/omarchy-zsh-theme.zsh.tpl при
# `omarchy theme set`. У темы Tea в папке темы лежит вербатим-копия исходного
# дизайна, поэтому вид с Tea не меняется; fallback — статичный tea.zsh-theme.
if [[ -f "$HOME/.local/state/omarchy/current/theme/omarchy-zsh-theme.zsh" ]]; then
  source "$HOME/.local/state/omarchy/current/theme/omarchy-zsh-theme.zsh"
else
  source "$HOME/.config/zsh/themes/tea.zsh-theme"
fi

# --- Плагины: пакеты дистрибутива или локальная копия ---
# Ищем в типовых местах Arch, Debian/Ubuntu, Fedora и в ~/.config/zsh/plugins.
# Если плагина нет — предупреждение, шелл продолжает работать.
_zsh_source_plugin() {
  local name=$1 file=$2 dir
  for dir in /usr/share/zsh/plugins/$name /usr/share/$name "$HOME/.config/zsh/plugins/$name"; do
    if [[ -r "$dir/$file" ]]; then
      source "$dir/$file"
      return 0
    fi
  done
  print -u2 "zsh: $name не найден; установите пакет или склонируйте в ~/.config/zsh/plugins/$name"
  return 1
}

_zsh_source_plugin zsh-autosuggestions zsh-autosuggestions.zsh
# zsh-syntax-highlighting должен загружаться последним.
_zsh_source_plugin zsh-syntax-highlighting zsh-syntax-highlighting.zsh
unfunction _zsh_source_plugin


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
