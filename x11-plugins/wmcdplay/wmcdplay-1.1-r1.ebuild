# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop

DESCRIPTION="CD player applet for WindowMaker"
HOMEPAGE="https://www.dockapps.net/wmcdplay"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/dockapps"

DOCS=( ARTWORK README )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	domenu "${FILESDIR}"/${PN}.desktop
}
