# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A backwards compatibility package for dev-lang/pypy:3.10"
HOMEPAGE="
	https://pypy.org/
	https://foss.heptapod.net/pypy/pypy/
"

LICENSE="metapackage"
SLOT="0/pypy310-pp73-384"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+gdbm ncurses sqlite +test-install tk"

RDEPEND="
	=dev-lang/pypy-3.10.${PV}*:3.10/${SLOT#*/}[gdbm?,ncurses?,sqlite?,symlink,test-install?,tk?]
"
