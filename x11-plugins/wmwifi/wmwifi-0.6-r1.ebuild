# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="wireless network interface monitor dockapp"
HOMEPAGE="https://www.dockapps.net/wmwifi"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_compile() {
	# by default it does not honour our CFLAGS
	emake CFLAGS="${CFLAGS}" CPPFLAGS="${CFLAGS}"
}

src_install() {
	dobin src/wmwifi
	doman wmwifi.1
	dodoc AUTHORS README
}
