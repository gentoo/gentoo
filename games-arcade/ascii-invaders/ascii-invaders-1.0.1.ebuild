# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Space invaders clone, using ncurses library"
HOMEPAGE="https://github.com/macdice/ascii-invaders"
SRC_URI="https://github.com/macdice/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc64 ~x86 ~ppc-macos"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	tc-export CC
	append-cppflags $($(tc-getPKG_CONFIG) --cflags ncurses || die)
	emake -f /dev/null LDLIBS="$($(tc-getPKG_CONFIG) ncurses --libs || die)" invaders
}

src_install() {
	newbin invaders ${PN}
	einstalldocs
}
