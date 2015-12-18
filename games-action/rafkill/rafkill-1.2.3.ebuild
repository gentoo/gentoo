# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils scons-utils games

DESCRIPTION="space shoot-em-up game"
HOMEPAGE="http://raptorv2.sourceforge.net/"
SRC_URI="mirror://sourceforge/raptorv2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="<media-libs/allegro-5
	media-libs/aldumb"
RDEPEND=${DEPEND}

src_prepare() {
	rm -f {data,music}/.sconsign
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "/^#define INSTALL_DIR/s:\.:${GAMES_DATADIR}:" \
		src/defs.cpp || die
}

src_compile() {
	escons
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data music
	dodoc README
	prepgamesdirs
}
