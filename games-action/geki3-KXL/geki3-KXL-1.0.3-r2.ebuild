# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/geki3-KXL/geki3-KXL-1.0.3-r2.ebuild,v 1.6 2015/01/01 12:11:53 tupone Exp $

EAPI=4
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
		src/ranking.c \
		|| die "sed failed"
	sed -i -e '/CFLAGS/s/$/ @CFLAGS@/' src/Makefile.am || die #bug 426890
	epatch "${FILESDIR}"/${P}-paths.patch
	mv configure.{in,ac}
	eautoreconf
}

src_install() {
	default
	emake DESTDIR="${D}" install
	insinto "${GAMES_STATEDIR}"
	newins data/.score ${PN}
	fperms g+w "${GAMES_STATEDIR}"/${PN}
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry geki3 Geki3
	prepgamesdirs
}
