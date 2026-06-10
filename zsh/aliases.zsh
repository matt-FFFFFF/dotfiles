alias reload!='. ~/.zshrc'
# force a full completion-dump rebuild (e.g. after adding a new _completion file)
alias reload-completions!='rm -f ${ZDOTDIR:-$HOME}/.zcompdump*(N) && exec zsh'
alias cls='clear' # Good 'ol Clear Screen command
alias grep='grep --color=auto $*'
alias ls='ls --color=auto $*'
## Use a long listing format ##
alias ll='ls -la $*'
## Show hidden files ##
alias l.='ls -d .* --color=auto $*'
alias ll.='ls -ld .* --color=auto $*'
## for when you forgot to ask nicely
alias pls='sudo $(fc -ln -1)'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
