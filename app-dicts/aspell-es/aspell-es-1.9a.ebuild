# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ASPELL_LANG="Spanish"
ASPOSTFIX="6"

inherit aspell-dict

MY_P="${P/aspell/aspell6}-1"
S=${WORKDIR}/${MY_P}
SRC_URI="mirror://gnu/aspell/dict/${SPELLANG}/${MY_P}.tar.bz2"

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""
