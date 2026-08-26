# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network interface bandwidth usage, with support for snmp targets"
HOMEPAGE="https://github.com/matttbe/ifstat"
SRC_URI="https://github.com/matttbe/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="snmp ssl"

DEPEND="
	snmp? ( >=net-analyzer/net-snmp-5.0 )
	ssl? ( dev-libs/openssl )
	"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-make.patch"
	"${FILESDIR}/${P}-bug_426262.patch"
	"${FILESDIR}/${P}-fix_switch.patch"
)
DOCS=( HISTORY README TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with snmp) \
		$(use_with ssl libcrypto) \
		--with-ifmib
}
