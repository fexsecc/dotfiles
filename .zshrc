source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source for autosuggestions
autoload -Uz compinit promptinit
compinit
promptinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ":completion:*:commands" rehash 1
setopt autocd # cd just by typing name
setopt interactivecomments # allow comments in interactive mode
setopt nonomatch # hide error message if nothing is found
setopt notify # report status of bg jobs immediately
setopt numericglobsort # sort items from A-Z when it makes sense
setopt promptsubst # enable cmd subst in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain chars part of the word

# hide stupid '%' sign
PROMPT_EOL_MARK=""

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char

HISTFILE=~/.config/zsh/zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# enable syntax-highlighting
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# configure prompt
PS1='%F{green}%n@%m[%~]$ '

#highlight matches in red with grep
alias grep="grep --color=always"

plugins=(git ssh-agent)

alias l="ls"
alias ls="ls --color=auto"
alias ll="ls -l --color=auto"
alias la="ls -la --color=auto"
alias cls="clear"
alias vim="nvim"
alias neofetch="screenfetch"
alias open="xdg-open"
#alias xclip="xclip -r -selection clipboard"
alias cat="bat --paging=never"
alias pwnssh="ssh hacker@dojo.pwn.college"
alias exprn="cp ~/code/python/template.py ./exploit.py"
alias venvrn="python -m venv venv; source ./venv/bin/activate"
alias lock="hyprlock"

export GPG_TTY=$(tty)

alias python=python3

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin"

. "$HOME/.local/share/../bin/env"
