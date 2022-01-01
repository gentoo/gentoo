# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fixheadtails.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Original author John Mylchreest <johnm@gentoo.org>
# @BLURB: functions to replace obsolete head/tail with POSIX compliant ones

# @FUNCTION: _do_sed_fix
# @INTERNAL
# @USAGE: <file>
# @DESCRIPTION:
# Apply series of regular expressions via sed to file
# to make head/tail compliant
_do_sed_fix() {
	einfo " - fixed $1"
	sed -i \
		-e 's/head \+-\([0-9]\)/head -n \1/g' \
		-e 's/tail \+\([-+][0-9]\+\)c/tail -c \1/g' \
		-e 's/tail \+\([-+][0-9]\)/tail -n \1/g' ${1} || \
			die "sed ${1} failed"
}

# @FUNCTION: ht_fix_file
# @USAGE: <files>
# @DESCRIPTION:
# Fix all the specified files.
ht_fix_file() {
	local i
	einfo "Replacing obsolete head/tail with POSIX compliant ones"
	for i in "$@" ; do
		_do_sed_fix "$i"
	done
}

# @FUNCTION: ht_fix_all
# @DESCRIPTION:
# Find and fix all files in the current directory as needed.
ht_fix_all() {
	local MATCHES
	MATCHES=$(grep -l -s -i -R -e "head -[ 0-9]" -e "tail [+-][ 0-9]" * | sort -u)
	[[ -n ${MATCHES} ]] \
		&& ht_fix_file ${MATCHES} \
		|| einfo "No need for ht_fix_all anymore !"
}
