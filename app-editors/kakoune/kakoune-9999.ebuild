# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs git-r3

DESCRIPTION="Selection-oriented code editor inspired by vim"
HOMEPAGE="https://github.com/mawww/kakoune"
EGIT_REPO_URI="https://github.com/mawww/kakoune.git"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	sys-libs/ncurses:=[unicode]
	dev-libs/boost
"
DEPEND="
	app-text/asciidoc
	virtual/pkgconfig
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-makefile.patch" )

src_configure() {
	append-cppflags $(pkg-config --cflags ncursesw)
	append-libs $(pkg-config --libs ncursesw)
	export CXX=$(tc-getCXX)
	export debug=$(usex debug)
	S="${WORKDIR}/${P}/src"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" docdir="${D}/usr/share/doc/${PF}" install
}
