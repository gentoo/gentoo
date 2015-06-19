# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/hexxagon/hexxagon-1.0.2.ebuild,v 1.4 2013/02/25 12:18:09 ago Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Clone of the original DOS game"
HOMEPAGE="http://www.nesqi.se/"
SRC_URI="http://www.nesqi.se/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install
	newicon images/board_N_2.xpm ${PN}.xpm
	make_desktop_entry ${PN} Hexxagon
	dodoc README
	prepgamesdirs
}
