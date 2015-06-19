# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/ri-li/ri-li-2.0.1.ebuild,v 1.9 2015/01/05 17:16:02 tupone Exp $

EAPI=5
inherit autotools eutils games

DESCRIPTION="Drive a toy wood engine and collect all the coaches"
HOMEPAGE="http://ri-li.sourceforge.net/"
SRC_URI="mirror://sourceforge/ri-li/Ri-li-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"
S=${WORKDIR}/Ri-li-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
	mv configure.{in,ac}
	rm aclocal.m4
	eautoreconf
}

src_install() {
	default
	rm -f "${D}${GAMES_DATADIR}/Ri-li/"*ebuild
	newicon data/Ri-li-icon-48x48.png ${PN}.png
	make_desktop_entry Ri_li Ri-li
	prepgamesdirs
}
