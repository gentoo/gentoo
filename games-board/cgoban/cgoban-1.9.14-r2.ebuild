# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A Go-frontend"
HOMEPAGE="http://cgoban1.sourceforge.net/"
SRC_URI="mirror://sourceforge/cgoban1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/imagemagick-tools
	x11-libs/libX11
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
)

src_prepare() {
	default
	cp cgoban_icon.png ${PN}.png || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	doicon ${PN}.png
	make_desktop_entry cgoban Cgoban
}
