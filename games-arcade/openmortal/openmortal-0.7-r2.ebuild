# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="A spoof of the famous Mortal Kombat game"
HOMEPAGE="http://openmortal.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-net
	>=media-libs/freetype-2.4.0:2
	dev-lang/perl
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	eapply \
		"${FILESDIR}/${P}"-gcc41.patch \
		"${FILESDIR}/${P}"-freetype.patch \
		"${FILESDIR}/${P}"-freetype_pkgconfig.patch
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	newicon data/gfx/icon.png ${PN}.png
	make_desktop_entry ${PN} OpenMortal
}
