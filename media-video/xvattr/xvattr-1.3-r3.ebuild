# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="X11 XVideo Querying/Setting Tool from Ogle project"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXv
	x11-libs/libXext
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	x11-libs/libXt"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gtk.patch
	"${FILESDIR}"/${P}-pod-encoding.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with gtk)
}
