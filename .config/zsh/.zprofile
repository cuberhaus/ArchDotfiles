# ~/.config/zsh/.zprofile
if [[ "$DISTRO" == "arch" ]]; then
    # [[ -f ~/.config/zsh/.zshrc ]] && . ~/.config/zsh/.zshrc
fi
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi
export GPG_TTY=$(tty)

