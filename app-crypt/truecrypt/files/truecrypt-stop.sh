# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2 or later

# Try to remove any dm-crypt mappings
if [ -x /usr/bin/truecrypt ]; then
	ebegin "Removing truecrypt mappings"
	! /usr/bin/truecrypt -l > /dev/null 2>&1  || /usr/bin/truecrypt -d
	eend $?
fi
