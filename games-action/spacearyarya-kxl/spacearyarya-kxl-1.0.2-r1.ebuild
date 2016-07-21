# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

MY_P=SpaceAryarya-KXL-${PV}
DESCRIPTION="A 2D/3D shooting game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-games/KXL"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi
	media-fonts/font-bitstream-100dpi"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo-paths.patch \
		"${FILESDIR}"/${P}-flags.patch
	mv configure.{in,ac}
	rm aclocal.m4
	eautoreconf
}

src_install() {
	default
	newicon bmp/enemy1.bmp ${PN}.bmp
	make_desktop_entry spacearyarya SpaceAryarya /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
