# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="A tool for logging raw data from a serial device"
HOMEPAGE="http://www.gtlib.cc.gatech.edu/pub/Linux/system/serial/logserial-0.4.2.lsm"
SRC_URI="http://www.gtlib.cc.gatech.edu/pub/Linux/system/serial/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

PATCHES=( "${FILESDIR}/${P}-gentoo.patch" )

src_configure() {
	tc-export CC
}

src_install() {
	dobin logserial
	dodoc CHANGELOG README
}
