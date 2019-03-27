# ZSH Git Prompt Plugin from:
# https://github.com/olivierverdier/zsh-git-prompt

__GIT_PROMPT_DIR="${0:A:h}"

## Hook function definitions
function chpwd_update_git_vars() {
    update_current_git_vars
}

function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

chpwd_functions+=(chpwd_update_git_vars)
precmd_functions+=(precmd_update_git_vars)
preexec_functions+=(preexec_update_git_vars)


## Function definitions
function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
    _GIT_STATUS=$(python ${gitstatus} 2>/dev/null)
     __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
    GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
    GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
    GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
    GIT_STAGED=$__CURRENT_GIT_STATUS[4]
    GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
    GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
    GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
}

git_super_status() {
    precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH"
      if [ "$GIT_BEHIND" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND"
      fi
      if [ "$GIT_AHEAD" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
      if [ "$GIT_STAGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED"
      fi
      if [ "$GIT_CONFLICTS" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS"
      fi
      if [ "$GIT_CHANGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED"
      fi
      if [ "$GIT_UNTRACKED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
      fi
      if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN_INTERNAL"
      fi
      STATUS="$STATUS%{$bg[$CURRENT_BG]$fg[$CURRENT_FG]%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      echo -n "$STATUS"
    fi
}

# Default values for the appearance of the prompt.
#ZSH_THEME_GIT_PROMPT_PREFIX="("
#ZSH_THEME_GIT_PROMPT_SUFFIX=")"
#ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
#ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
#ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
#ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
#ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
#ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
#ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}%{…%G%}"
#ZSH_THEME_GIT_PROMPT_CLEAN_INTERNAL="%{✔%G%}"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH=""
ZSH_THEME_GIT_PROMPT_STAGED="%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN_INTERNAL="%{✔%G%}"

# Set the prompt.
#RPROMPT='$(git_super_status)'
