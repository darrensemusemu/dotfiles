typeset -U path # Remove duplicate entries from PATH
path=($path $HOME/.darren/bin) # Append to PATH

autoload -Uz compinit
compinit


export EDITOR='vim' # Preferred editor for local and remote sessions
bindkey -v # we can edit usin vi/vim bindings

# Stop HomeBrew from doing anythin but update everytime.
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# Colors from ghostty/themes/sunbather
local yellow="#F3E430"      # sunbather: yellow
local pink="#d75f87"        # sunbather: light_pink
local blue="#008EC4"        # sunbather: dark_blue
local gray="#A8A8A8"        # sunbather: light_gray
local green="#10A778"       # sunbather: dark_green
local cyan="#20A5BA"        # sunbather: dark_cyan
local red="#C30771"         # sunbather: dark_red


# Enable command substitution and parameter expansion in prompt
setopt PROMPT_SUBST

#setopt PROMPT_SUBST
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY      # Append history to the history file
setopt SHARE_HISTORY       # Share history across all sessions
setopt HIST_IGNORE_DUPS    # Do not store duplicate commands
setopt HIST_SAVE_NO_DUPS   # Do not save duplicate commands to the history file
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first when history is full
setopt HIST_VERIFY         # Don't execute immediately upon history expansion
setopt HIST_FCNTL_LOCK     # Lock history file for concurrent access
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
            echo " %F{$cyan}($branch)%f"
        else
            # Dirty repository
            echo " %F{$red}($branch*)%f"
        fi
    fi
}

# Primary prompt
PROMPT='][ %F{$yellow}%n%f ][ %F{$pink}%m%f in %F{$blue}%~%f$(git_status)
+%F{$gray}➜%f '

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
