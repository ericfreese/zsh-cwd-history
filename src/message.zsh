
#--------------------------------------------------------------------#
# Display a Message                                                  #
#--------------------------------------------------------------------#

_zsh_cwd_history_message() {
	local message=$1

	if zle; then
		zle -Rc "" $message
	else
		echo $message
	fi
}
