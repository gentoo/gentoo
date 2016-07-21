# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

main() {
	# We need to properly terminate devfsd to save the permissions
	if [[ -n $(ps --no-heading -C 'devfsd') ]]; then
		ebegin "Stopping devfsd"
		killall -15 devfsd &>/dev/null
		eend $?
	fi
}

main


# vim:ts=4
