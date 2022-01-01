# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="Romanian"
ASPELL_VERSION=5
MY_P="${PN/aspell/aspell${ASPELL_VERSION}}-${PV}"

inherit aspell-dict-r1

HOMEPAGE="
	http://aspell.net
	https://rospell.wordpress.com/
"
SRC_URI="mirror://sourceforge/rospell/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
