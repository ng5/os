# shellcheck shell=bash
export ZSH=~/.oh-my-zsh
export PROMPT_EOL_MARK=''
# shellcheck disable=SC2034
ZSH_THEME="robbyrussell"
plugins=(fzf-tab zsh-syntax-highlighting zsh-autosuggestions docker docker-compose git adb redis-cli fzf rsync zfs-completion postgres)
checkSource $ZSH/oh-my-zsh.sh
set -o allexport
checkSource ~/Bitbucket/dotfiles/.env
set +o allexport
checkSource ~/Bitbucket/build/da_utils.sh
checkSource ~/Bitbucket/dotfiles/.myrc
checkSource ~/.fzf.zsh
checkSource ~/miniconda3/etc/profile.d/conda.sh
checkSource ~/.cargo/env
alias 1="source ~/.zshrc"
export FZF_DEFAULT_OPTS="-i --ansi --bind alt-k:preview-page-up,alt-j:preview-page-down --height 100% --preview 'fzfPreview {}' "
export FZF_DEFAULT_COMMAND="fd "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d "

# shellcheck disable=SC2154
export PROMPT="%{$fg_bold[red]%}%n@%m ${PROMPT}"
export PATH=$PATH:~/go/bin:~/Android/Sdk/platform-tools:~/Android/Sdk/tools:/usr/local/go/bin:~/miniconda3/bin:/usr/share/bcc/tools
export EDITOR=vim
unsetopt AUTO_CD
unsetopt nomatch
