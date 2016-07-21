# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A freecell game for X"
HOMEPAGE="http://www2.giganet.net/~nakayama/"
SRC_URI="http://www2.giganet.net/~nakayama/${P}.tgz
	http://www2.giganet.net/~nakayama/MSNumbers.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

RDEPEND="x11-libs/libXext
	media-fonts/font-misc-misc"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-gcc43.patch
}

src_install() {
	dogamesbin xfreecell
	insinto "${GAMES_DATADIR}"/${PN}
	doins "${WORKDIR}"/MSNumbers
	dodoc CHANGES README mshuffle.txt
	doman xfreecell.6
	make_desktop_entry xfreecell XFreecell
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "Remember to restart X if this is the first time you've installed media-fonts/font-misc-misc"
}
