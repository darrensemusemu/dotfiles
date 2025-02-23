PATH="$PATH:$HOME/.darren/bin"



export EDITOR='vim' # Preferred editor for local and remote sessions
bindkey -v # we can edit usin vi/vim bindings

# Stop HomeBrew from doing anythin but update everytime.
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# Coffee Book ZSH Prompt Configuration
# For raw zsh without Oh My Zsh

# Color definitions matching your palette
local yellow="#eaa549"
local magenta="#97522c"
local blue="#426a79"
local brown="#858162"
local green="#989a9c"

# Enable command substitution and parameter expansion in prompt
setopt PROMPT_SUBST

#setopt PROMPT_SUBST
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
#PROMPT='%B%(?..%F{red}%?%f )%F{blue}%~ %F{green}%#%f%b '
#RPROMPT='%B%F{red}$(git branch --show-current 2> /dev/null)%f%b'

# Git status information
function git_status() {
    local ref branch
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref=$(git rev-parse --short HEAD 2> /dev/null)
    branch="${ref#refs/heads/}"

    if [[ -n "$branch" ]]; then
        local git_repo_status
        git_repo_status=$(git status --porcelain 2> /dev/null)

        if [[ -z "$git_repo_status" ]]; then
            # Clean repository
            echo " %F{cyan}($branch)%f"
        else
            # Dirty repository
            echo " %F{red}($branch*)%f"
        fi
    fi
}

# Primary prompt
PROMPT='][ %F{$yellow}%n%f ][ %F{$magenta}%m%f in %F{$blue}%~%f$(git_status)
%F{$brown}➜%f '

# Right prompt with timestamp
RPROMPT='%F{$green}[%*]%f'

## Ensure vi mode indicators work
#function zle-keymap-select {
#    zle reset-prompt
#    zle -R
#}
#zle -N zle-keymap-select
#
## Set cursor shape based on vi mode
#function set-cursor-shape-for-keymap() {
#    case $KEYMAP in
#        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
#        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # vertical line cursor
#    esac
#}

# Autoload required modules
#autoload -Uz add-zsh-hook
#add-zsh-hook precmd set-cursor-shape-for-keymap
