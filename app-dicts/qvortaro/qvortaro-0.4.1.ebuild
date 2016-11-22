# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils qt4-r2

DESCRIPTION="Esperanto Dictionary"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtgui:4
	dev-qt/qtsql:4
"

PATCHES=( "${FILESDIR}/${P}-gcc45.patch" )

src_install() {
	dobin qvortaro
	newicon src/img/icon_16.png ${PN}.png
	make_desktop_entry ${PN} qVortaro
	dodoc readme.txt
}
