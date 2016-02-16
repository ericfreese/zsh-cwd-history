
#--------------------------------------------------------------------#
# Hooks                                                              #
#--------------------------------------------------------------------#

# Initialize on first command prompt, then remove the hook
_zsh_cwd_history_hook_precmd() {
	_zsh_cwd_history_cwd_changed
	add-zsh-hook -d precmd _zsh_cwd_history_hook_precmd
}

_zsh_cwd_history_hook_chpwd() {
	_zsh_cwd_history_cwd_changed
}

_zsh_cwd_history_hook_zshaddhistory() {
	_zsh_cwd_history_write_cwd_entry $@
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_cwd_history_hook_precmd
add-zsh-hook chpwd _zsh_cwd_history_hook_chpwd
add-zsh-hook zshaddhistory _zsh_cwd_history_hook_zshaddhistory
