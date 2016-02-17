
#--------------------------------------------------------------------#
# Zsh Hooks                                                          #
#--------------------------------------------------------------------#

# Initialize on first prompt, then remove the precmd hook
_zsh_cwd_history_initialize() {
	# Simulate initial chpwd
	_zsh_cwd_history_cwd_changed

	# Add a hook to switch histfiles on chpwd
	_zsh_cwd_history_add_cwd_hook

	# Remove the precmd hook
	add-zsh-hook -d precmd _zsh_cwd_history_initialize
}

# Load history for current working directory when changing dirs
_zsh_cwd_history_cwd_changed() {
	local cwd_histfile=$(_zsh_cwd_history_histfile_for_cwd)

	# Save a reference to any original histfile from outside our dir
	if [ "${HISTFILE:A:h}" != "$ZSH_CWD_HISTORY_DIR" ]; then
		_ZSH_CWD_HISTORY_ORIG_HISTFILE="$HISTFILE"
	fi

	# Switch the histfile
	_zsh_cwd_history_switch_histfile $cwd_histfile

	# Show message if necessary
	if $ZSH_CWD_HISTORY_SHOW_CHPWD_MSG; then
		_zsh_cwd_history_message "Using cwd histfile: $HISTFILE"
	fi
}

# Add the chpwd hook
_zsh_cwd_history_add_cwd_hook() {
	add-zsh-hook chpwd _zsh_cwd_history_cwd_changed
}

# Remove the chpwd hook
_zsh_cwd_history_remove_cwd_hook() {
	add-zsh-hook -d chpwd _zsh_cwd_history_cwd_changed
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_cwd_history_initialize
