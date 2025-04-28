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
PS1='%F{blue}%n@%m[%~]$ '

#highlight matches in red with grep
alias grep="grep --color=always"

plugins=(git ssh-agent)

alias l="ls"
alias ls="ls --color=auto"
alias ll="ls -l --color=auto"
alias la="ls -la --color=auto"
alias cls="clear"
alias vim="nvim"
alias firefox="/opt/firefox-container/run.sh&"
alias neofetch="screenfetch"
alias open="xdg-open"
alias xclip="xclip -r -selection clipboard"
alias cat="bat --paging=never"

export GPG_TTY=$(tty)
export PATH="/home/neo/.scripts/:$PATH"

alias hows-my-gpu='lspci -nnk | grep -C 3 -i nvidia'
alias nvidia-enable='sudo virsh nodedev-reattach pci_0000_01_00_0 && echo "GPU reattached (now host ready)" && sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1 && echo "VFIO drivers removed" && sudo modprobe -i nvidia nvidia_uvm nvidia_wmi_ec_backlight && echo "NVIDIA drivers added" && echo "COMPLETED!"'
alias nvidia-disable='sudo modprobe -r nvidia_wmi_ec_backlight nvidia && echo "NVIDIA drivers removed" && sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1 && echo "VFIO drivers added" && sudo virsh nodedev-detach pci_0000_01_00_0 && echo "GPU detached (now vfio ready)" && echo "COMPLETED!"'
alias looking-glass='looking-glass-client -s -m 97 &'
alias volup='pactl set-source-volume 1 +1%'
alias voldown='pactl set-source-volume 1 -1%'
alias disable-sleep='xset s off; xset -dpms'
alias enable-sleep='xset s on; xset +dpms'
