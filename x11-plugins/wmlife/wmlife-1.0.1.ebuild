# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="dockapp running Conway's Game of Life (and program launcher)"
HOMEPAGE="http://www.improbability.net/#wmlife"
SRC_URI="http://www.improbability.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.0-stringh.patch
	epatch "${FILESDIR}"/${P}-configure.patch

	eautoreconf
}

src_configure() {
	econf --enable-session
}
