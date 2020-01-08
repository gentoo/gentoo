# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Spanish"
ASPELL_VERSION=6

inherit aspell-dict-r1

MY_P="${P/aspell/aspell6}-1"

SRC_URI="mirror://gnu/aspell/dict/${ASPELL_SPELLANG}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}
