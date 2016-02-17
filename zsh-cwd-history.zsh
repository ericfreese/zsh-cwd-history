# Scope history to the current working directory.
# Idea from https://github.com/jimhester/per-directory-history
# https://github.com/ericfreese/zsh-cwd-history
# v0.2.1
# Copyright (c) 2016 Eric Freese
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

#--------------------------------------------------------------------#
# Global Config Variables                                            #
#--------------------------------------------------------------------#

ZSH_CWD_HISTORY_DIR="$HOME/.zsh_cwd_history"
ZSH_CWD_HISTORY_SHOW_TOGGLE_MSG=true
ZSH_CWD_HISTORY_SHOW_CHPWD_MSG=false

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
