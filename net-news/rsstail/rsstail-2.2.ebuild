# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A tail-like RSS-reader"
HOMEPAGE="
	https://www.vanheusden.com/rsstail/
	https://github.com/folkertvanheusden/rsstail
"
SRC_URI="
	https://github.com/folkertvanheusden/rsstail/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="virtual/pkgconfig"
DEPEND=">=net-libs/libmrss-0.17.1"
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -DVERSION=\\\"\$(VERSION)\\\"" \
		LDFLAGS="${LDFLAGS} $($(tc-getPKG_CONFIG) --libs mrss)"
}

src_test() {
	# Skip as it's just cppcheck.
	# We don't run lints for ebuilds.
	:;
}

src_install() {
	dobin rsstail
	doman rsstail.1
	dodoc README.md
}
