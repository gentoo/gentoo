# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Keepalive daemon for vpnc on Linux systems"
HOMEPAGE="https://github.com/dcantrell/vpncwatch/"
SRC_URI="https://github.com/downloads/dcantrell/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-vpn/vpnc"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	einstalldocs
}
