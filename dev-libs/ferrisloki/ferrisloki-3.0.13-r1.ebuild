# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils flag-o-matic multilib

DESCRIPTION="Loki C++ library from Modern C++ Design"
HOMEPAGE="http://www.libferris.com/"
SRC_URI="mirror://sourceforge/witme/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs stlport"

RDEPEND="stlport? ( >=dev-libs/STLport-5 )
	>=dev-libs/libsigc++-2.6:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# derice this damn configure script
	sed -i \
		-e '/^CFLAGS/{s: -O3 : :g;s:-Wl,-O1 -Wl,--hash-style=both::;}' \
		-e 's:-lstlport_gcc:-lstlport:' \
		configure || die

	# Fix building with libsigc++-2.6
	find -name '*.h' -exec sed -i '/sigc++\/object.h/d' {} + || die
	find -name '*.hh' -exec sed -i '/sigc++\/object.h/d' {} + || die

	epatch_user
}

src_configure() {
	append-cxxflags -std=c++11
	econf \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-stlport="${EPREFIX}/usr/include/stlport" \
		$(use_enable stlport) \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
