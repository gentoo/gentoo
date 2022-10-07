# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Portable version of Joe's Own Editor"
HOMEPAGE="http://www.mirbsd.org/jupp.htm"
SRC_URI="http://www.mirbsd.org/MirOS/dist/${PN}/joe-${PV/_p/${PN}}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

RDEPEND="ncurses? ( sys-libs/ncurses:0= )
	!app-editors/joe"
DEPEND="${RDEPEND}"

DOCS="HINTS INFO LIST NEWS README TODO"

src_configure() {
	chmod +x configure || die
	econf \
		--enable-search_libs \
		--enable-termcap \
		$(use_enable ncurses curses)
}
