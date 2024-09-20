# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Support library to deal with Apple Property Lists (Binary & XML)"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-pkgconfig-lib.patch
)

src_configure() {
	local myeconfargs=(
		--disable-static
		--without-cython
		$(use_with test tests)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -name '*.la' -delete || die

	# bugs #733082, #915375
	dosym ./libplist-2.0.pc /usr/$(get_libdir)/pkgconfig/libplist.pc
	dosym ./libplist++-2.0.pc /usr/$(get_libdir)/pkgconfig/libplist++.pc
	dosym ./libplist++-2.0.so.4.6.0 /usr/$(get_libdir)/libplist++.so
	dosym ./libplist-2.0.so.4.6.0 /usr/$(get_libdir)/libplist.so
}
