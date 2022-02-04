# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Network interface bandwidth usage, with support for snmp targets"
HOMEPAGE="http://gael.roualland.free.fr/ifstat/"
SRC_URI="http://gael.roualland.free.fr/ifstat/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 ~riscv sparc x86"
IUSE="snmp"

DEPEND="snmp? ( >=net-analyzer/net-snmp-5.0 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
	"${FILESDIR}"/${P}-hardened.patch
)
DOCS=( HISTORY README TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with snmp)
}
