# /etc/bash/bashrc.d/10-gentoo-title.bash

# Set window title with the Title Definition String sequence. For screen, the
# sequence defines the window title (%t) and for tmux, the pane_title (#T).
# For tmux to be affected requires that its allow-rename option be enabled.
# https://www.gnu.org/software/screen/manual/html_node/Control-Sequences.html
case ${TERM} in
	screen*|tmux*)
		genfun_set_pane_title() {
			printf '\033k%s\033\\' "${HOSTNAME%%.*}"
		}
		PROMPT_COMMAND+=('genfun_set_pane_title')
		;;
	*)
		# If the TTY is that of sshd(8) then proceed no further. Alas,
		# there exist many operating environments in which the window
		# title would otherwise not be restored upon ssh(1) exiting.
		if [[ ${SSH_TTY} && ${SSH_TTY} == "$(tty)" ]]; then
			return
		fi
esac

# Assigns the basename of the current working directory, having sanitised it
# with @Q parameter expansion. Useful for paths containing newlines and such.
# As a special case, names consisting entirely of graphemes shall not undergo
# the parameter expansion, for reasons of cleanliness.
genfun_sanitise_cwd() {
	_cwd=${PWD##*/}
	if [[ ! ${_cwd} ]]; then
		_cwd=${PWD}
	elif [[ ${_cwd} == *[![:graph:]]* ]]; then
		_cwd=${_cwd@Q}
	fi
}

# Set window title with the Set Text Parameters sequence. For screen, the
# sequence defines the hardstatus (%h) and for tmux, the window_name (#W).
# For graphical terminal emulators, it is normal for the title bar be affected.
# The only terminals permitted here are those for which there is empirical
# evidence that the sequence is supported and that the UTF-8 character encoding
# is handled correctly. Quite rightly, this precludes many vintage terminals.
# https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands
case ${TERM} in
	alacritty     |\
	foot*         |\
	rxvt-unicode* |\
	screen*       |\
	tmux*         |\
	xterm*        )
		genfun_set_win_title() {
			genfun_sanitise_cwd
			printf '\033]2;%s@%s - %s\007' "${USER}" "${HOSTNAME%%.*}" "${_cwd}"
		}
		PROMPT_COMMAND+=('genfun_set_win_title')
esac
