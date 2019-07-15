# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

IUSE=""
DESCRIPTION="Window Maker dock applet resembling a miniature pinboard"
SRC_URI="https://github.com/bbidulock/${PN}/releases/download/${PV}/${P}.tar.gz"
HOMEPAGE="https://github.com/bbidulock/wmpinboard"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/wmpinboard-1.0-segfault.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
}
