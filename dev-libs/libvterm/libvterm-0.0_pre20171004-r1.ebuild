# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="http://www.leonerd.org.uk/code/libvterm/"
SRC_URI="https://dev.gentoo.org/~tranquility/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

BDEPEND="virtual/pkgconfig"
DEPEND="sys-devel/libtool"
RDEPEND="!dev-libs/libvterm-neovim"

src_compile() {
	append-cflags -fPIC
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" install

	find "${D}" -name '*.la' -delete || die

	if ! use static-libs; then
		find "${ED}" -name '*.a' ! -name '*.dll.a' -delete || die
	fi
	dodoc doc/*
}
