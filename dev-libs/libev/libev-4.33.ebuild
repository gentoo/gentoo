# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="A high-performance event loop/event model with lots of feature"
HOMEPAGE="http://software.schmorp.de/pkg/libev.html"
SRC_URI="http://dist.schmorp.de/libev/${P}.tar.gz
	http://dist.schmorp.de/libev/Attic/${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="static-libs"

DOCS=( Changes README )

# bug #411847
PATCHES=( "${FILESDIR}/${PN}-4.25-pc.patch" )

src_prepare() {
	default
	sed -i -e "/^include_HEADERS/s/ event.h//" Makefile.am || die

	eautoreconf
}

src_configure() {
	# See bug #855869 and its large number of dupes in bundled libev copies.
	filter-lto
	append-flags -fno-strict-aliasing

	multilib-minimal_src_configure
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--disable-maintainer-mode \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	if ! use static-libs; then
		find "${ED}" -name '*.la' -type f -delete || die
	fi

	einstalldocs
}
