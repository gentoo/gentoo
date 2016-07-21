# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

main() {
	local mymounts=$(awk '($2 == "devfs") { print "yes"; exit 0 }' /proc/filesystems)
	
	# Is devfs support compiled in?
	if [[ ${mymounts} == "yes" ]] ; then
		if [[ ${devfs_automounted} == "no" ]] ; then
			ebegin "Mounting devfs at /dev"
			try mount -n -t devfs devfs /dev
			eend $?
		else
			ebegin "Kernel automatically mounted devfs at /dev"
			eend 0
		fi
		ebegin "Starting devfsd"
		/sbin/devfsd /dev >/dev/null
		eend $? "Could not start /sbin/devfsd"
	else
		devfs="no"
	fi
}

main


# vim:ts=4
