# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
HOMEPAGE="https://www.phildev.net/iptstate/ https://github.com/jaymzh/iptstate"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7:0=
	>=net-libs/libnetfilter_conntrack-0.0.50
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	tc-export CXX PKG_CONFIG
}

src_install() {
	emake PREFIX="${D}"/usr install
	dodoc BUGS Changelog CONTRIB README WISHLIST
}
