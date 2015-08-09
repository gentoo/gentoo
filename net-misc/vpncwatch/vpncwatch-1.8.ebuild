# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A keepalive daemon for vpnc on Linux systems"
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
