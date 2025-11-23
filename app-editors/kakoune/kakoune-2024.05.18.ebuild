# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Modal editor inspired by vim"
HOMEPAGE="https://kakoune.org/ https://github.com/mawww/kakoune"
SRC_URI="https://github.com/mawww/kakoune/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	sed -i '/CXXFLAGS-debug-no = -O3 -g3/d' Makefile || die
	sed -i '/CXX = c++/d' Makefile || die
	default
}

src_configure() {
	tc-export CXX
}

src_compile() {
	emake all
}

src_test() {
	emake test
}

src_install() {
	emake PREFIX="${D}"/usr docdir="${ED}/usr/share/doc/${PF}" install

	rm "${ED}/usr/share/man/man1/kak.1.gz" || die
	doman doc/kak.1
}
