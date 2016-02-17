
#--------------------------------------------------------------------#
# Toggle Widget                                                      #
#--------------------------------------------------------------------#

# Implementation for toggle widget
_zsh_cwd_history_toggle() {
	if [ "$HISTFILE" = "$_ZSH_CWD_HISTORY_ORIG_HISTFILE" ]; then
		# Switch to the cwd histfile
		_zsh_cwd_history_switch_histfile $(_zsh_cwd_history_histfile_for_cwd)

		# Add back the cwd hook
		_zsh_cwd_history_add_cwd_hook

		# Show message if necessary
		if $ZSH_CWD_HISTORY_SHOW_TOGGLE_MSG; then
			_zsh_cwd_history_message "Using cwd histfile: $HISTFILE"
		fi
	else
		# Switch to the original histfile
		_zsh_cwd_history_switch_histfile $_ZSH_CWD_HISTORY_ORIG_HISTFILE

		# Temporarily remove the cwd hook
		_zsh_cwd_history_remove_cwd_hook

		# Show message if necessary
		if $ZSH_CWD_HISTORY_SHOW_TOGGLE_MSG; then
			_zsh_cwd_history_message "Using original histfile: $HISTFILE"
		fi
	fi
}

# Create the toggle widget
zle -N cwd-history-toggle _zsh_cwd_history_toggle
