# /etc/bash/bashrc.d/10-gentoo-color.bash

if [[ ${NO_COLOR} ]]; then
	# Respect the user's wish not to use color. See https://no-color.org/.
	gentoo_color=0
elif [[ ${COLORTERM@a} == *x* && ${COLORTERM} == @(24bit|truecolor) ]]; then
	# The COLORTERM environment variable can reasonably be trusted here.
	# See https://github.com/termstandard/colors for further information.
	gentoo_color=1
elif unset -v COLORTERM; ! gentoo_color=$(tput colors 2>/dev/null); then
	# Either ncurses is not installed or no terminfo database could be
	# found. Fall back to a whitelist which covers the majority of terminal
	# emulators and virtual console implementations known to support color
	# and which remain (somewhat) popular. This will rarely happen, so the
	# list need not be exhaustive.
	case ${TERM} in
		*color*    |\
		*direct*   |\
		[Ekx]term* |\
		alacritty  |\
		aterm      |\
		dtterm     |\
		foot*      |\
		jfbterm    |\
		linux      |\
		mlterm     |\
		rxvt*      |\
		screen*    |\
		tmux*      |\
		wsvt25*    ) gentoo_color=1
	esac
elif (( gentoo_color == 16777216 )); then
	# Truecolor support is available. Advertise it.
	export COLORTERM=truecolor
fi

# For direxpand to be missing indicates that bash is lacking readline support.
if (( gentoo_color <= 0 )) || [[ ! $(shopt -p direxpand 2>/dev/null) ]]; then
	# Define a prompt without color.
	PS1='\u@\h \w \$ '
elif (( EUID == 0 )); then
	# If root, omit the username and print the hostname in red.
	PS1='\[\e[01;31m\]\h\[\e[01;34m\] \w \$\[\e[00m\] '
else
	# Otherwise, print the username and hostname in green.
	PS1='\[\e[01;32m\]\u@\h\[\e[01;34m\] \w \$\[\e[00m\] '
fi

if (( gentoo_color > 0 )); then
	# Colorize the output of diff(1), grep(1) and a few coreutils utilities.
	for _ in diff dir grep ls vdir; do
		alias "$_=$_ --color=auto"
	done

	# Enable colors for ls(1) and some other utilities that respect the
	# LS_COLORS variable. Prefer ~/.dir_colors, per bug #64489.
	if hash dircolors 2>/dev/null; then
		if [[ -f ~/.dir_colors ]]; then
			eval "$(dircolors -b -- ~/.dir_colors)"
		elif [[ -f /etc/DIR_COLORS ]]; then
			eval "$(dircolors -b /etc/DIR_COLORS)"
		else
			eval "$(dircolors -b)"
		fi
	fi
fi

unset -v gentoo_color
