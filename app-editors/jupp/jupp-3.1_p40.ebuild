# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Portable version of Joe's Own Editor"
HOMEPAGE="https://www.mirbsd.org/jupp.htm"
SRC_URI="https://www.mirbsd.org/MirOS/dist/${PN}/joe-${PV/_p/${PN}}.tgz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

RDEPEND="ncurses? ( sys-libs/ncurses:0= )
	!app-editors/joe"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"
DOCS="HINTS INFO LIST NEWS README TODO"

src_prepare() {
	default
	chmod +x configure || die
}

src_configure() {
	econf \
		--enable-search_libs \
		--enable-termcap \
		$(use_enable ncurses curses)
}
