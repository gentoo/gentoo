# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Network packet sniffer and injector"
HOMEPAGE="http://hexinject.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tools experimental"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}
	experimental? ( dev-lang/tcl )"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	append-cflags -std=gnu89
	tc-export CC
}

src_install() {
	dobin hexinject
	use tools && dobin hex2raw prettypacket
	use experimental && dobin packets.tcl
	einstalldocs
}
