# This theme for gitprompt.sh is optimized for the "Solarized Dark" and "Solarized Light" color schemes
# tweaked for Ubuntu terminal fonts

override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom"
  GIT_PROMPT_STAGED="${Yellow}●"
  GIT_PROMPT_STASHED="${BoldMagenta}⚑ "
  GIT_PROMPT_CLEAN="${Green}✔"
  GIT_PROMPT_END_USER="\n${White}$ ${ResetColor}"
  GIT_PROMPT_END_ROOT="\n# "
  GIT_PROMPT_START_USER="${Yellow}${PathShort} _LAST_COMMAND_INDICATOR_"
  GIT_PROMPT_START_ROOT="${GIT_PROMPT_START_USER}"
}

reload_git_prompt_colors "Custom"
