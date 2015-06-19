# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iptstate/iptstate-2.2.5.ebuild,v 1.6 2014/07/12 18:20:58 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
HOMEPAGE="http://www.phildev.net/iptstate/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7
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
