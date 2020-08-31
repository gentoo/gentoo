# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A tail-like RSS-reader"
HOMEPAGE="http://www.vanheusden.com/rsstail/ https://github.com/flok99/rsstail"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND=">=net-libs/libmrss-0.17.1"
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -DVERSION=\\\"\$(VERSION)\\\"" \
		LDFLAGS="${LDFLAGS} $(pkg-config --libs mrss)"
}

src_install() {
	dobin rsstail
	doman rsstail.1
	dodoc README.md
}
