# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils flag-o-matic

DESCRIPTION="Clone of the original DOS game"
HOMEPAGE="http://www.nesqi.se/"
SRC_URI="http://www.nesqi.se/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default

	append-cxxflags -std=c++11
}

src_install() {
	emake DESTDIR="${D}" install
	newicon images/board_N_2.xpm ${PN}.xpm
	make_desktop_entry ${PN} Hexxagon
	dodoc README
}
