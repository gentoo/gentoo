# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="An active/passive address reconnaissance tool"
HOMEPAGE="https://github.com/netdiscover-scanner/netdiscover"
LICENSE="GPL-2"
SRC_URI="
	https://github.com/${PN}-scanner/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=net-libs/libpcap-0.8.3-r1
"
RDEPEND="
	${DEPEND}
"
S=${WORKDIR}/${P/_/-}
DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	default
}
