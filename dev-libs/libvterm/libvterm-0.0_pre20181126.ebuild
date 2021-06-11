# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="http://www.leonerd.org.uk/code/libvterm/"
SRC_URI="https://dev.gentoo.org/~tranquility/distfiles/${P}.tar.gz"
S="${WORKDIR}"/libvterm-0.0

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig"
RDEPEND="!dev-libs/libvterm-neovim"

src_compile() {
	tc-export CC
	append-cflags -fPIC

	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" install

	find "${ED}" -name '*.la' -delete || die
}
