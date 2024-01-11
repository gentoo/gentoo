# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Abstraction layer to simplify PKCS#11 API"
HOMEPAGE="https://github.com/opensc/libp11/wiki"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:=[bindist(+)]
	|| (
		(
			>=dev-libs/openssl-3.1.0
			<dev-libs/openssl-3.1.4
		)
		(
			>=dev-libs/openssl-3.0.0
			<dev-libs/openssl-3.0.12
		)
	)
"
DEPEND="${RDEPEND}
	test? ( dev-libs/softhsm )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? ( >=dev-libs/opensc-0.23.0-r2 )
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/libp11-0.4.12-openssl-3.1.patch
	)
	default
	eautoreconf
}

src_configure() {
	local args=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable doc api-doc)
	)
	econf "${args[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
