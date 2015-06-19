# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vpncwatch/vpncwatch-1.8.1.ebuild,v 1.1 2013/04/01 13:14:16 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Keepalive daemon for vpnc on Linux systems"
HOMEPAGE="http://github.com/dcantrell/vpncwatch/"
SRC_URI="http://github.com/downloads/dcantrell/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/vpnc"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-Makefile.patch"
	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc README ChangeLog AUTHORS
}
