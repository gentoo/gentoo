# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit versionator

MY_PV="$(replace_all_version_separators '')"
MY_P="${PN}_${MY_PV}_linux"

DESCRIPTION="UCI-only chess engine"
HOMEPAGE="http://arctrix.com/nas/fruit/"
SRC_URI="http://arctrix.com/nas/${PN}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}"-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		option.cpp || die
	sed -i \
		-e '/^CXX/d' \
		-e '/^LDFLAGS/d' \
		Makefile || die
}

src_install() {
	dobin ${PN}
	insinto "/usr/share/${PN}"
	doins ../book_small.bin
	dodoc ../readme.txt ../technical_10.txt
}
