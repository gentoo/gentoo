# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs vcs-snapshot

REF="9298efd19bd024f96df3eab0cef92d03581969ba"

DESCRIPTION="Selection-oriented code editor inspired by vim"
HOMEPAGE="https://github.com/mawww/kakoune"
SRC_URI="https://github.com/mawww/${PN}/tarball/${REF} -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	sys-libs/ncurses:*[unicode]
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
	export CXX=$(tc-getCXX)
	export debug=$(usex debug)
}

src_compile() {
	emake -C src
}

src_test() {
	emake -C src test
}

src_install() {
	emake -C src DESTDIR="${D}" PREFIX="/usr" install
}
