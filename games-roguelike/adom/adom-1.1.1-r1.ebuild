# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix

DESCRIPTION="Ancient Domains Of Mystery rogue-like game"
HOMEPAGE="https://www.adom.de/"
SRC_URI="https://www.adom.de/adom/download/linux/${P//.}-elf.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="adom"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip" # bug #137340

RDEPEND="sys-libs/ncurses-compat:5[abi_x86_32(-)]"

src_install() {
	exeinto /opt/bin
	doexe adom

	keepdir /var/lib/${PN}
	echo /var/lib/${PN} > adom_ds.cfg || die

	insinto /etc
	doins adom_ds.cfg

	edos2unix adomfaq.txt
	dodoc adomfaq.txt manual.doc readme.1st
}
