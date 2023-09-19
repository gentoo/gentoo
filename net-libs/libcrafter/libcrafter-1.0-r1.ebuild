# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A high level C++ network packet sniffing and crafting library"
HOMEPAGE="https://github.com/pellegre/libcrafter"
SRC_URI="https://github.com/pellegre/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-version-${PV}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.3_p20171019-libpcap.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	dodoc "${WORKDIR}"/${PN}-version-${PV}/README

	find "${ED}" -name '*.la' -delete || die
}
