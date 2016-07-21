# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="2D length scroll shooting game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-games/KXL"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi"

src_prepare() {
	rm -f missing
	sed -i \
		-e '1i #include <string.h>' \
		-e "s:DATA_PATH \"/.score\":\"${GAMES_STATEDIR}/${PN}\":" \
		src/ranking.c || die
	epatch \
		"${FILESDIR}"/${P}-paths.patch \
		"${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_install() {
	default
	insinto "${GAMES_STATEDIR}"
	newins data/.score ${PN}
	fperms g+w "${GAMES_STATEDIR}"/${PN}
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry geki2 Geki2
	prepgamesdirs
}
