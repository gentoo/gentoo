# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A BSON utility library"
HOMEPAGE="https://github.com/mongodb/libbson"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~x86"
IUSE="debug examples static-libs"

src_configure() {
	econf --disable-optimizations \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install() {
	default

	# Installing all the manuals conflicts with man-pages
	doman doc/man/bson_*.3

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi

	if use examples; then
		docinto examples
		dodoc examples/*.c
	fi

	einstalldocs
}

src_test() {
	emake test
}
