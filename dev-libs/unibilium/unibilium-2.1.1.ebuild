# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A very basic terminfo library"
HOMEPAGE="https://github.com/neovim/unibilium/"
SRC_URI="https://github.com/neovim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+ MIT"
SLOT="0/4"
KEYWORDS="amd64 arm arm64 ~riscv x86 ~x64-macos"
IUSE="static-libs"

BDEPEND="dev-lang/perl
	dev-build/libtool"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-no-compress-man.patch"
)

src_compile() {
	append-flags -fPIC
	tc-export CC
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" all
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" DESTDIR="${D}" install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/lib${PN}.a || die
	rm "${ED}"/usr/$(get_libdir)/lib${PN}.la || die
}
