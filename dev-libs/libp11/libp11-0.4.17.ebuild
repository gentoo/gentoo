# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Releases are signed by Michał Trojnara of stunnel
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/stunnel.asc
inherit autotools verify-sig

DESCRIPTION="Abstraction layer to simplify PKCS#11 API"
HOMEPAGE="https://github.com/opensc/libp11/wiki"
SRC_URI="
	https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz
	verify-sig? ( https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz.asc )
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/openssl-3.0.0:=[bindist(+)]
"
DEPEND="${RDEPEND}
	test? ( dev-libs/softhsm )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? ( >=dev-libs/opensc-0.23.0-r2 )
	verify-sig? ( sec-keys/openpgp-keys-stunnel )
"

src_prepare() {
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
