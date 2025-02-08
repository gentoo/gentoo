# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A backwards compatibility package for dev-lang/pypy:3.11"
HOMEPAGE="
	https://pypy.org/
	https://foss.heptapod.net/pypy/pypy/
"

LICENSE="metapackage"
SLOT="0/pypy311-pp73-400"
IUSE="+gdbm ncurses sqlite +test-install tk"

RDEPEND="
	=dev-lang/pypy-3.11.${PV}*:3.11/${SLOT#*/}[gdbm?,ncurses?,sqlite?,symlink,test-install?,tk?]
"
