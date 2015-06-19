# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libopkele/libopkele-2.0.4-r1.ebuild,v 1.1 2014/05/26 05:25:48 polynomial-c Exp $

EAPI=5

inherit eutils

DESCRIPTION="A C++ implementation of an OpenID decentralized identity system"
HOMEPAGE="http://kin.klever.net/libopkele/"
SRC_URI="http://kin.klever.net/dist/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/htmltidy
	dev-libs/libpcre
	dev-libs/openssl
	net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc471.patch \
		"${FILESDIR}"/${P}-missing_includes.patch
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS
}
