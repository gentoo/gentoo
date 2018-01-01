# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

IUSE=""
DESCRIPTION="Window Maker dock applet resembling a miniature pinboard"
SRC_URI="https://github.com/bbidulock/${PN}/releases/download/${PV}/${P}.tar.gz"
HOMEPAGE="https://github.com/bbidulock/wmpinboard"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc alpha amd64 ppc"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/wmpinboard-1.0-segfault.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
}
