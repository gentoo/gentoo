# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
HOMEPAGE="http://www.phildev.net/iptstate/ https://github.com/jaymzh/iptstate"
SRC_URI="https://github.com/jaymzh/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7:0=
	>=net-libs/libnetfilter_conntrack-0.0.50
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.2.5-gentoo.patch
)

src_prepare() {
	default
	tc-export CXX PKG_CONFIG
}

src_install() {
	emake PREFIX="${D}"/usr install
	dodoc BUGS Changelog CONTRIB README.md WISHLIST
}
