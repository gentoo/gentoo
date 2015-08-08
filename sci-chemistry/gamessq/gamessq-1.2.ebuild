# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="Simple job manager for GAMESS-US"
HOMEPAGE="http://www.msg.chem.iastate.edu/GAMESS/GamessQ/"
SRC_URI="http://www.msg.chem.iastate.edu/GAMESS/GamessQ/download/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="x11-libs/wxGTK:${WX_GTK_VER}"
RDEPEND="${DEPEND}"

src_install() {
	default
	doicon src/icons/${PN}.ico
	make_desktop_entry ${PN} gamessq ${PN}.ico "Science;Education"
}
