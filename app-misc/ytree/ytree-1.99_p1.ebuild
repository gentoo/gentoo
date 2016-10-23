# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="${PN}-1.99pl1"
inherit toolchain-funcs

DESCRIPTION="A curses-based file manager"
HOMEPAGE="http://www.han.de/~werner/ytree.html"
SRC_URI="http://www.han.de/~werner/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES README THANKS ytree.conf )
PATCHES=( "${FILESDIR}/${PN}-1.94-bindir.patch" )

pkg_setup() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}usr" install
	einstalldocs
}
