# tea.zsh-theme — plain zsh prompt matched to the Omarchy "Tea" theme.
#
# Two-line layout:
#   Line 1: tag-style bands — user account first (cyan #7FA5B8; red
#           #B0725E when the shell runs under a foreign account, e.g.
#           root/su), then the directory in Tea's accent green (#4E8570),
#           then the git branch in lighter green (#6FA08A). The line always
#           starts with a rounded left cap (U+E0B6) in the first band's
#           color, every band ends with a right powerline wedge (U+E0B0)
#           drawn in that band's own color over the next band's background
#           (over the terminal background for the last band).
#   Line 2: arrow ❯ in Tea green (red when the last command failed);
#           the typed input keeps normal terminal colors.
#
# Palette values come from ~/.config/omarchy/themes/tea/colors.toml.
# Needs a Nerd Font (JetBrainsMono Nerd Font is Omarchy's default).

# Account this config belongs to, captured once at source time; the precmd
# below recolors the user band when the shell runs under someone else
# (root, su/sudo to another user). One `id -un` per prompt is cheap next to
# the per-prompt git call already made below.
typeset -g _TEA_PRIMARY_USER="$(id -un)"

function prompt_tea_precmd() {
  local code=$? # must be captured before anything else runs

  # --- Tea palette (truecolor, wrapped in %{..%} so ZLE counts no width) ---
  local ACCENT_BG=$'%{\e[48;2;78;133;112m%}'  # accent green (segment bg)
  local LIGHT_BG=$'%{\e[48;2;111;160;138m%}'  # light green (git segment bg)
  local INK_FG=$'%{\e[38;2;26;32;32m%}'       # dark_background — text on green
  local LIGHT_FG=$'%{\e[38;2;111;160;138m%}'  # light green — closing wedge fg
  local ACCENT_FG=$'%{\e[38;2;78;133;112m%}'  # accent green — closing wedge fg
  local GREEN_FG=$'%{\e[38;2;162;199;180m%}'  # bright green — prompt arrow
  local RED_FG=$'%{\e[38;2;192;137;116m%}'    # bright red — failed command
  local CYAN_BG=$'%{\e[48;2;127;165;184m%}'   # cyan — user segment bg
  local RED_BG=$'%{\e[48;2;176;114;94m%}'     # red — user segment bg (foreign account)
  local RESET=$'%{\e[0m%}'
  local CLOSE_LIGHT=$'%{\e[49m\e[38;2;111;160;138m%}' # reset bg -> light wedge
  local CLOSE_ACCENT=$'%{\e[49m\e[38;2;78;133;112m%}' # reset bg -> accent wedge
  local WEDGE=$'\ue0b0' # powerline wedge U+E0B0 (seams and closing edge)
  local CAP=$'\ue0b6'   # powerline rounded left cap U+E0B6
  # Rounded line start: reset (paranoia), then first band's color as fg.
  local CAP_CYAN=$'%{\e[0m\e[38;2;127;165;184m%}'
  local CAP_RED=$'%{\e[0m\e[38;2;176;114;94m%}'
  # Band seams: background = next band, foreground = previous band, so the
  # wedge drawn right after points right in the previous band's color.
  local SEAM_CYAN=$'%{\e[48;2;78;133;112m\e[38;2;127;165;184m%}'
  local SEAM_RED=$'%{\e[48;2;78;133;112m\e[38;2;176;114;94m%}'
  local SEAM_DIR=$'%{\e[48;2;111;160;138m\e[38;2;78;133;112m%}'
  # --- directory: "…/last-two" once the path gets deep ---
  local slashes="${PWD//[^\/]/}"
  if (( ${#slashes} > 3 )); then
    local dir="…/${(%):-%2~}"
  else
    local dir="${(%):-%~}"
  fi

  # --- git branch (fast; falls back to a short SHA when detached) ---
  local branch=""
  if branch=$(git symbolic-ref --short -q HEAD 2>/dev/null) || branch=$(git rev-parse --short HEAD 2>/dev/null); then
    branch="$branch"
  else
    branch=""
  fi

  # --- user: first band; red under a foreign account (root, su) ---
  local user="$(id -un)"
  local USER_BG=$CYAN_BG USER_CAP=$CAP_CYAN USER_SEAM=$SEAM_CYAN
  [[ "$user" != "$_TEA_PRIMARY_USER" ]] && { USER_BG=$RED_BG; USER_CAP=$CAP_RED; USER_SEAM=$SEAM_RED; }

  local top="${USER_CAP}${CAP}${USER_BG}${INK_FG} ${user} ${USER_SEAM}${WEDGE}${INK_FG} ${dir} "
  if [[ -n "$branch" ]]; then
    top+="${SEAM_DIR}${WEDGE}${INK_FG} ${branch} ${CLOSE_LIGHT}${WEDGE}${RESET} "
  else
    top+="${CLOSE_ACCENT}${WEDGE}${RESET} "
  fi

  local arrow
  if (( code )); then
    arrow="${RED_FG}❯${RESET}"
    RPROMPT="${RED_FG}✘ ${code}${RESET}"
  else
    arrow="${GREEN_FG}❯${RESET}"
    RPROMPT=""
  fi

  PROMPT="$top"$'\n'"$arrow "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_tea_precmd
