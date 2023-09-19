# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="https://www.leonerd.org.uk/code/libvterm/"
SRC_URI="https://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86 ~x64-macos"

BDEPEND="
	dev-lang/perl
	sys-devel/libtool
"

src_compile() {
	emake VERBOSE=1 PREFIX="${EPREFIX}"/usr LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake VERBOSE=1 DESTDIR="${D}" PREFIX="${EPREFIX}"/usr LIBDIR="${EPREFIX}/usr/$(get_libdir)" install

	find "${ED}" -name '*.la' -delete || die "Failed to prune libtool files"
	find "${ED}" -name '*.a' -delete || die
}
