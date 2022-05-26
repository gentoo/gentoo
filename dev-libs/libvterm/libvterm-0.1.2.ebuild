# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="http://www.leonerd.org.uk/code/libvterm/"
SRC_URI="http://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

BDEPEND="
	dev-lang/perl
	sys-devel/libtool
	virtual/pkgconfig
"
RDEPEND="!dev-libs/libvterm-neovim"

src_compile() {
	tc-export CC
	append-cflags -fPIC

	emake VERBOSE=1 PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake \
		VERBOSE=1 \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" install

	find "${ED}" -name '*.la' -delete || die "Failed to prune libtool files"
}
