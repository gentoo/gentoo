# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Keepalive daemon for vpnc on Linux systems"
HOMEPAGE="https://github.com/dcantrell/vpncwatch/"
SRC_URI="https://github.com/dcantrell/vpncwatch/archive/refs/tags/${P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${P}

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
