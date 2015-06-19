# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/qvortaro/qvortaro-0.4.1.ebuild,v 1.4 2014/01/24 20:04:19 creffett Exp $

EAPI=5
inherit eutils qt4-r2

DESCRIPTION="Esperanto Dictionary"
HOMEPAGE="http://qvortaro.berlios.de/"
SRC_URI="mirror://berlios/qvortaro/${P}.tar.gz"

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
	dobin qvortaro || die
	newicon src/img/icon_16.png ${PN}.png
	make_desktop_entry ${PN} qVortaro
	dodoc readme.txt
}
