# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A keepalive daemon for vpnc on Linux systems"
HOMEPAGE="https://github.com/dcantrell/vpncwatch/"
SRC_URI="https://github.com/downloads/dcantrell/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-vpn/vpnc"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-Makefile.patch"
	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc README ChangeLog AUTHORS
}
