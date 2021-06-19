# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Space invaders clone, using ncurses library"
HOMEPAGE="https://packages.gentoo.org/package/games-arcade/ascii-invaders"
SRC_URI="mirror://gentoo/invaders${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc64 ~x86 ~ppc-macos"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/invaders"

src_prepare() {
	default
	rm -f Makefile
}

src_compile() {
	emake LDLIBS="$($(tc-getPKG_CONFIG) ncurses --libs)" invaders
}

src_install() {
	newbin invaders ${PN}
	einstalldocs
}
