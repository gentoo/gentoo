# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A version of the classic game Mastermind"
HOMEPAGE="https://github.com/bderrly/braincurses"
SRC_URI="https://github.com/bderrly/braincurses/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	emake CXX=$(tc-getCXX) LDLIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

src_install() {
	dobin braincurses
	einstalldocs
}
