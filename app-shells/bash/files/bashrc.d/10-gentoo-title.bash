# /etc/bash/bashrc.d/10-gentoo-title.bash

genfun_set_win_title() {
	# Assigns the basename of the current working directory, having
	# sanitised it with @Q parameter expansion. Useful for paths containing
	# newlines and such. As a special case, names consisting entirely of
	# graphemes shall not undergo the expansion, for reasons of cleanliness.
	genfun_sanitise_cwd() {
		_cwd=${PWD##*/}
		if [[ ! ${_cwd} ]]; then
			_cwd=${PWD}
		elif [[ ${_cwd} == *[![:graph:]]* ]]; then
			_cwd=${_cwd@Q}
		fi
	}

	# Sets the window title with the Set Text Parameters sequence. For
	# screen, the sequence defines the hardstatus (%h) and for tmux, the
	# pane_title (#T). For graphical terminal emulators, it is normal for
	# the title bar to be affected.
	genfun_set_win_title() {
		genfun_sanitise_cwd
		printf '\033]0;%s@%s - %s\007' "${USER}" "${HOSTNAME%%.*}" "${_cwd}"
	}

	genfun_set_win_title
}

# Proceed no further if the TTY is that of sshd(8) and if not running a terminal
# multiplexer. Alas, there exist many operating environments in which the window
# title would otherwise not be restored upon ssh(1) exiting. Those who wish for
# the title to be set unconditionally may adjust ~/.bashrc - or create a custom
# bashrc.d drop-in - to define PROMPT_COMMAND=(genfun_set_win_title).
if [[ ${SSH_TTY} && ${TERM} != @(screen|tmux)* && ${SSH_TTY} == "$(tty)" ]]; then
	return
fi

# Determine whether the terminal can handle the Set Text Parameters sequence.
# The only terminals permitted here are those for which there is empirical
# evidence that the sequence is supported and that the UTF-8 character encoding
# is handled correctly. Quite rightly, this precludes many vintage terminals.
# https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands
case ${TERM} in
	alacritty     |\
	foot*         |\
	rxvt-unicode* |\
	screen*       |\
	st-256color   |\
	tmux*         |\
	xterm*        )
		PROMPT_COMMAND+=('genfun_set_win_title')
esac
