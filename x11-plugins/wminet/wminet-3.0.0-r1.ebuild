# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="dockapp for monitoring internet connections to and from your computer"
HOMEPAGE="http://www.improbability.net/#wminet"
SRC_URI="http://www.improbability.net/wmdock//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-list.patch

	tc-export CC
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README wminetrc
}
