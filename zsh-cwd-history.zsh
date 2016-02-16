# Scope history to the current working directory.
# Based on https://github.com/jimhester/per-directory-history
# https://github.com/ericfreese/zsh-cwd-history
# v0.1.0
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
# Global Configuration Variables                                     #
#--------------------------------------------------------------------#

ZSH_CWD_HISTORY_DIR="$HOME/.zsh_cwd_history"

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
