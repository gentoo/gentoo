# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ASPELL_LANG="Belarusian"

inherit eutils aspell-dict

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

SRC_URI="mirror://gnu/aspell/dict/be/aspell5-be-${PV}.tar.bz2"
IUSE="classic"

S="${WORKDIR}/aspell5-be-${PV}"

src_unpack() {
	unpack ${A}
	use classic || epatch "${FILESDIR}"/aspell5-be-${PV}-official.patch
}
