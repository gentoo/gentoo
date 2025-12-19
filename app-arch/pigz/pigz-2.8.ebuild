# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/madler.asc
inherit toolchain-funcs flag-o-matic verify-sig

DESCRIPTION="A parallel implementation of gzip"
HOMEPAGE="https://www.zlib.net/pigz/"
SRC_URI="
	https://www.zlib.net/pigz/${P}.tar.gz
	verify-sig? ( https://www.zlib.net/pigz/${P}-sig.txt -> ${P}.tar.gz.asc )
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="static test"
RESTRICT="!test? ( test )"

LIB_DEPEND=">=virtual/zlib-1.2.3:=[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
	test? ( app-arch/ncompress )
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-madler )"

src_compile() {
	use static && append-ldflags -static
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dosym ${PN} /usr/bin/un${PN}
	dodoc README
	doman ${PN}.1
}
