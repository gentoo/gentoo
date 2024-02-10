# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

COMMIT="0b23b367c98de8882b58a451742a3f2e385c4ba0"
DESCRIPTION="A tail-like RSS-reader"
HOMEPAGE="http://www.vanheusden.com/rsstail/ https://github.com/flok99/rsstail"
SRC_URI="https://github.com/flok99/rsstail/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

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
