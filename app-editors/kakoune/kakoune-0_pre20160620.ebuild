# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs vcs-snapshot

REF="34c8e6a9cf15410a433c8a8c3901703708b85611"

DESCRIPTION="Selection-oriented code editor inspired by vim"
HOMEPAGE="https://github.com/mawww/kakoune"
SRC_URI="https://github.com/mawww/${PN}/tarball/${REF} -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
