# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A BSON utility library"
HOMEPAGE="https://github.com/mongodb/libbson"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="debug examples static-libs"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	default_src_prepare
	# https://github.com/mongodb/mongo-c-driver/issues/54
	sed -i -e "s/PTHREAD_LIBS/PTHREAD_CFLAGS/g" src/bson/Makefile.am \
		tests/Makefile.am || die
	eautoreconf
}

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
