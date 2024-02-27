# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic autotools

DESCRIPTION="Loki C++ library from Modern C++ Design"
HOMEPAGE="https://data-room-software.org/libferris/"
SRC_URI="mirror://sourceforge/witme/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-libs/libsigc++-2.6:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.13-r3-configure-libsigc.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11

	econf
}

src_install() {
	default

	# package provides .pc files
	find "${ED}" -name '*.la' -delete || die
}
