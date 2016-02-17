
#--------------------------------------------------------------------#
# Histfile Helper Functions                                          #
#--------------------------------------------------------------------#

# Echo the name of the history file to use for current working dir
# Uses the md5 hash of the absolute path
_zsh_cwd_history_histfile_for_cwd() {
	echo "$ZSH_CWD_HISTORY_DIR/.hist-$(echo "${PWD:A}" | md5 -q)"
}

# Switch to a new history file, writing to the old one
_zsh_cwd_history_switch_histfile() {
	local new_histfile=$1

	# Write old histfile
	fc -P

	# Read new histfile
	fc -p "$new_histfile"
}
