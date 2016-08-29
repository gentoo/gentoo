# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="The somehow different FTP client"
HOMEPAGE="http://oneclickftp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-crypt/qca:2[qt4(+)]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-qt47.patch"
)

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	doicon res/icons/${PN}.png
	make_desktop_entry ${PN} ${PN}

	einstalldocs
}
