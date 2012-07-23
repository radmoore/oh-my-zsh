# Based on jnrowe's theme. Added screen and ssh indication to prompt
# as well as hostname

ssh_color="red"
screen_color="red"
host_color="blue"

autoload -U add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
    '%F{2}%s%F{7}:%F{2}(%F{1}%b%F{2})%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

add-zsh-hook precmd prompt_jnrowe_precmd

prompt_jnrowe_precmd () {
    vcs_info

    if [ "${vcs_info_msg_0_}" = "" ]; then
        dir_status="%F{2}→%f"
    elif [[ $(git diff --cached --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%F{1}▶%f"
    elif [[ $(git diff --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%F{3}▶%f"
    else
        dir_status="%F{2}▶%f"
    fi
}

SSH="%B%{$fg[$ssh_color]%}|SSH|%b"
SCREEN="%B%{$fg[$screen_color]%}|SCREEN|%b"
if pidof sshd | grep -q $PPID
then
  context="%{%}$SSH "
elif [ $TERM = "screen" ]
then
  context="%{%}$SCREEN "
else
  context=""
fi

host="[%B%{$fg[$host_color]%}%M%b]"

local ret_status="%(?:%{$fg_bold[green]%}Ξ:%{$fg_bold[red]%}%S↑%s%?)"

PROMPT='$host$context${ret_status}%{$fg_bold[green]%}%p %{$fg_bold[yellow]%}%2~ ${vcs_info_msg_0_}${dir_status}%{$reset_color%} '
