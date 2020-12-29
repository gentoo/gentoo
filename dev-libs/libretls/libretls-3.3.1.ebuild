# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Port of libtls from LibreSSL to OpenSSL"
HOMEPAGE="https://git.causal.agency/libretls/about/"
SRC_URI="https://causal.agency/libretls/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/openssl:="
RDEPEND="${DEPEND}
	!dev-libs/libressl"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myconf=(
		--disable-static
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
