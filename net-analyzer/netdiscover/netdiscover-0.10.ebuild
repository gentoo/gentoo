# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Active/passive address reconnaissance tool"
HOMEPAGE="https://github.com/netdiscover-scanner/netdiscover"
SRC_URI="
	https://github.com/${PN}-scanner/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=net-libs/libpcap-0.8.3-r1
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	default
}
