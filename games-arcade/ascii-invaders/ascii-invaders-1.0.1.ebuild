# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Space invaders clone, using ncurses library"
HOMEPAGE="https://github.com/macdice/ascii-invaders"
SRC_URI="https://github.com/macdice/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc64 ~x86 ~ppc-macos"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	rm -f Makefile
}

src_compile() {
	tc-export CC
	emake LDLIBS="$($(tc-getPKG_CONFIG) ncurses --libs)" invaders
}

src_install() {
	newbin invaders ${PN}
	einstalldocs
}
