
#--------------------------------------------------------------------#
# History Functions                                                  #
#--------------------------------------------------------------------#

# Echo the name of the history file for current working directory
_zsh_cwd_history_cwd_histfile() {
	# Uses the md5 hash of the absolute path of cwd
	echo "$ZSH_CWD_HISTORY_DIR/.hist-$(echo ${PWD:A} | md5 -q)"
}

# Clear history record by resetting $HISTSIZE
_zsh_cwd_history_clear_history() {
	local histsize=$HISTSIZE
	HISTSIZE=0
	HISTSIZE=$histsize
}

# Load history for the current working directory
_zsh_cwd_history_load_cwd_history() {
	local histfile=$(_zsh_cwd_history_cwd_histfile)

	# If the histfile exists, read the history from it
	if [ -f $histfile ]; then
		fc -R $(_zsh_cwd_history_cwd_histfile)
	fi
}

# Load history for current working directory when changing dirs
_zsh_cwd_history_cwd_changed() {
	_zsh_cwd_history_clear_history
	_zsh_cwd_history_load_cwd_history
}

# Write a history entry for current working directory
_zsh_cwd_history_write_cwd_entry() {
	local histfile=$(_zsh_cwd_history_cwd_histfile)

	# Format the history entry
	print -Sr -- ${1%%$'\n'}

	# Ensure the directory exists
	[ -d "${histfile:h}" ] || mkdir -p ${histfile:h}

	# Write the history entry
	fc -p $histfile
}
