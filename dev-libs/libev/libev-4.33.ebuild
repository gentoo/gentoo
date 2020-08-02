# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils multilib-minimal

DESCRIPTION="A high-performance event loop/event model with lots of feature"
HOMEPAGE="http://software.schmorp.de/pkg/libev.html"
SRC_URI="http://dist.schmorp.de/libev/${P}.tar.gz
	http://dist.schmorp.de/libev/Attic/${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="static-libs"

DOCS=( Changes README )

# bug #411847
PATCHES=( "${FILESDIR}/${PN}-4.25-pc.patch" )

src_prepare() {
	default
	sed -i -e "/^include_HEADERS/s/ event.h//" Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--disable-maintainer-mode \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	if ! use static-libs; then
		find "${D}" -name '*.la' -type f -delete || die
	fi
	einstalldocs
}
