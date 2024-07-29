# /etc/bash/bashrc.d/10-gentoo-title.bash

# For information regarding the control sequences used, please refer to
# https://invisible-island.net/xterm/ctlseqs/ctlseqs.html.

genfun_set_win_title() {
	# Advertise the fact that the presently running interactive shell will
	# update the title. Doing so allows for its subprocesses to determine
	# whether it is safe to set the title of their own accord. Note that 0
	# refers to the value of Ps within the OSC Ps ; Pt BEL sequence.
	export SHELL_SETS_TITLE=0

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

	# Sets the window title with the Set Text Parameters control sequence.
	# For screen, the sequence defines the hardstatus (%h) and for tmux, the
	# pane_title (#T). For graphical terminal emulators, it is normal for
	# the title bar to be affected.
	genfun_set_win_title() {
		genfun_sanitise_cwd
		printf '\033]0;%s@%s - %s\007' "${USER}" "${HOSTNAME%%.*}" "${_cwd}"
	}

	genfun_set_win_title
}

unset -v SHELL_SETS_TITLE

# Determine whether the terminal can handle the Set Text Parameters sequence.
# The only terminals permitted here are those for which there is empirical
# evidence that the sequence is supported and that the UTF-8 character encoding
# is handled correctly. Quite rightly, this precludes many vintage terminals.
case ${TERM} in
	alacritty|foot*|tmux*)
		# The terminal emulator also supports XTWINOPS. If the PTY was
		# created by sshd(8) then push the current window title to the
		# stack and arrange for it to be popped upon exiting. Xterm also
		# supports this but there are far too many terminal emulators
		# that falsely identify as being xterm-compatible.
		if [[ ${SSH_TTY} && ${SSH_TTY} == "$(tty)" ]]; then
			trap 'printf "\033[23;0t"' EXIT
			printf '\033[22;0t'
		fi
		;;
	rxvt-unicode*|st-256color|xterm*)
		# If the PTY was created by sshd(8) then proceed no further.
		# Alas, there exist many operating environments in which the
		# title would otherwise not be restored upon ssh(1) exiting.
		# Those wanting for the title to be set regardless may adjust
		# ~/.bashrc or create a bashrc.d drop-in to set PROMPT_COMMAND.
		# For example, PROMPT_COMMAND=(genfun_set_win_title).
		if [[ ${SSH_TTY} && ${SSH_TTY} == "$(tty)" ]]; then
			return
		fi
		;;
	screen*)
		# If the PTY was created by sshd(8) and screen(1) was launched
		# prior to the SSH session beginning, as opposed to afterwards,
		# proceed no further. It is another case in which there would be
		# no guarantee of the title being restored upon ssh(1) exiting.
		if [[ ! ${WINDOW} && ${SSH_TTY} && ${SSH_TTY} == "$(tty)" ]]; then
			return
		fi
		;;
	*)
		return
esac

# Arrange for the title to be updated each time the primary prompt is displayed.
PROMPT_COMMAND+=('genfun_set_win_title')
