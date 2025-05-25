# /etc/bash/bashrc.d/10-gentoo-color.bash

if [[ ${NO_COLOR} ]]; then
	# Respect the user's wish not to use color. See https://no-color.org/.
	gentoo_color=0
elif [[ ${COLORTERM@a} == *x* && ${COLORTERM} == @(24bit|truecolor) ]]; then
	# The COLORTERM environment variable can reasonably be trusted here.
	# See https://github.com/termstandard/colors for further information.
	gentoo_color=1
else
	# Check TERM against a whitelist covering a majority of popular
	# terminal emulators and virtual console implementations known to
	# support color. If no matching entry is found, try to use tput(1) to
	# determine whether color is supported.
	case ${TERM} in
		*color*    |\
		*direct*   |\
		*ghostty   |\
		[Ekx]term* |\
		alacritty  |\
		aterm      |\
		contour    |\
		dtterm     |\
		foot*      |\
		jfbterm    |\
		linux      |\
		mlterm     |\
		rxvt*      |\
		screen*    |\
		tmux*      |\
		wsvt25*    ) gentoo_color=1 ;;
		*          ) gentoo_color=$(tput colors 2>/dev/null)
	esac
fi

# For direxpand to be missing indicates that bash is lacking readline support.
if (( gentoo_color <= 0 )) || ( ! shopt -u direxpand 2>/dev/null ); then
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
	# However, do so only where no alias/function by the given name exists.
	for _ in diff dir grep ls vdir; do
		if [[ $(type -t "$_") == file ]]; then
			alias "$_=$_ --color=auto"
		fi
	done

	# Enable colors for ls(1) and some other utilities that respect the
	# LS_COLORS variable. Prefer ~/.dir_colors, per bug #64489.
	if hash dircolors 2>/dev/null; then
		if [[ -f ~/.dir_colors ]]; then
			eval "$(COLORTERM=1 dircolors -b -- ~/.dir_colors)"
		elif [[ -f /etc/DIR_COLORS ]]; then
			eval "$(COLORTERM=1 dircolors -b /etc/DIR_COLORS)"
		else
			eval "$(COLORTERM=1 dircolors -b)"
		fi
	fi
fi

unset -v gentoo_color
