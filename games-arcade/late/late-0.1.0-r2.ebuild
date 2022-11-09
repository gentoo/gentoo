# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Game similar to Barrack by Ambrosia Software"
HOMEPAGE="http://late.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/late/${P}.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[jpeg]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc46.patch
)

src_prepare() {
	default

	# handle score file and permissions ourselves
	sed -i '/score/d;/chgrp/d' Makefile.in || die

	# want /var/games rather than /var/lib/lib/games
	sed -i "s|LOCALSTATEDIR\"/lib|\"${EPREFIX}/var|" src/arch.cpp || die
}

src_install() {
	default

	dodir /var/games
	:> "${ED}"/var/games/${PN}.scores || die

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.scores
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.scores

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
