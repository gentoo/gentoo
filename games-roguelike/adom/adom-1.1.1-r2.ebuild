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

# bug #137340
RESTRICT="strip"
QA_FLAGS_IGNORED="/opt/bin/adom"

RDEPEND="sys-libs/ncurses-compat:5[abi_x86_32(-)]"

src_install() {
	exeinto /opt/bin
	doexe adom

	insinto /etc
	echo "${EPREFIX}"/var/lib/${PN} > adom_ds.cfg || die
	doins adom_ds.cfg

	edos2unix adomfaq.txt
	dodoc adomfaq.txt manual.doc readme.1st

	keepdir /var/lib/${PN}
	fperms g+w /var/lib/${PN}
}
