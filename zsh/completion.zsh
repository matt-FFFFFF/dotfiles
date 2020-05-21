# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# enbable completion menu
zstyle ':completion:*' menu select

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
