# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Support library to deal with Apple Property Lists (Binary & XML)"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://cgit.libimobiledevice.org/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-pkgconfig-lib.patch
	"${FILESDIR}"/${PN}-2.3.0-test-rename.patch
	"${FILESDIR}"/${PN}-2.3.0-configure-c99.patch
)

src_prepare() {
	default
	RELEASE_VERSION=${PV} eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--without-cython
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
	dosym ./libplist++-2.0.so.4.3.0 /usr/$(get_libdir)/libplist++.so
	dosym ./libplist-2.0.so.4.3.0 /usr/$(get_libdir)/libplist.so
}
