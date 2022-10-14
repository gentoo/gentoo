# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="'Sticky' Honeypot and IDS"
HOMEPAGE="http://labrea.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_p*}-stable-${PV/*_p}.tar.gz"
S="${WORKDIR}/${P/_p/-stable-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="
	net-libs/libpcap
	>=dev-libs/libdnet-1.7
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README{,.first} TODO NEWS )

PATCHES=(
	"${FILESDIR}"/${P/_p/-stable-}-incdir.patch
	"${FILESDIR}"/${P/_p*}-pcap_open.patch
	"${FILESDIR}"/${PN}-2.5-libdir.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	# autotools will overwrite this with the generic version
	mv INSTALL README.first || die

	mv configure.{in,ac} || die

	eautoreconf
}

pkg_postinst() {
	ewarn "Before using this package please read the README.first and README as"
	ewarn "the author states that it can cause serious problems on your network"
}
