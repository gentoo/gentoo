# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: edos2unix.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: convert files from DOS CRLF to UNIX LF line endings

# @FUNCTION: edos2unix
# @USAGE: <file> [more files ...]
# @DESCRIPTION:
# A handy replacement for ``dos2unix``, ``recode``, ``fixdos``, etc...  This
# allows you to remove all of these text utilities from ``DEPEND`` variables
# because this is a script based solution.  Just give it a list of files
# to convert and they will all be changed from the DOS CRLF format to
# the UNIX LF format.

edos2unix() {
	[[ $# -eq 0 ]] && return 0
	sed -i 's/\r$//' -- "$@" || die
}
