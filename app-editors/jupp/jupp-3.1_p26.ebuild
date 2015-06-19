# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/jupp/jupp-3.1_p26.ebuild,v 1.1 2013/11/08 06:21:36 patrick Exp $

EAPI=4

DESCRIPTION="portable version of JOE's Own Editor"
HOMEPAGE="https://www.mirbsd.org/jupp.htm"
SRC_URI="https://www.mirbsd.org/MirOS/dist/${PN}/joe-${PV/_p/${PN}}.tgz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

RDEPEND="ncurses? ( sys-libs/ncurses )
	!app-editors/joe"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	chmod +x configure
}

src_configure() {
	econf \
		--enable-search_libs \
		--enable-termcap \
		$(use_enable ncurses curses)
}

src_install() {
	default
	dodoc HINTS INFO LIST
}
