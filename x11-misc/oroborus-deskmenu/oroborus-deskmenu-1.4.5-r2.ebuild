# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PN="${PN/oroborus-//}"

DESCRIPTION="root menu program for Oroborus"
HOMEPAGE="https://www.oroborus.org"
SRC_URI="mirror://debian/pool/main/d/${MY_PN}/${MY_PN}_${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# bug 875131
	"${FILESDIR}"/${P}-Wimplicit-function-declaration.patch
)

src_prepare() {
	default
	eautoreconf # bug 898252
}

src_install() {
	default
	dodoc example_rc
}
