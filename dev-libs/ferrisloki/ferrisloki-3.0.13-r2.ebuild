# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Loki C++ library from Modern C++ Design"
HOMEPAGE="http://www.libferris.com/"
SRC_URI="mirror://sourceforge/witme/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	>=dev-libs/libsigc++-2.6:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default

	# derice this damn configure script
	sed -i \
		-e '/^CFLAGS/{s: -O3 : :g;s:-Wl,-O1 -Wl,--hash-style=both::;}' \
		-e 's:-lstlport_gcc:-lstlport:' \
		configure || die

	# Fix building with libsigc++-2.6
	find -name '*.h' -exec sed -i '/sigc++\/object.h/d' {} + || die
	find -name '*.hh' -exec sed -i '/sigc++\/object.h/d' {} + || die
}

src_configure() {
	append-cxxflags -std=c++11

	econf \
		--disable-stlport \
		$(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
