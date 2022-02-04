# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Mouse gestures for X"
HOMEPAGE="https://github.com/deters/mygestures"
SRC_URI="https://github.com/deters/mygestures/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libxml2
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	dobin src/mygestures #814482

	dodoc README.md

	insinto /etc
	doins mygestures.xml
}
