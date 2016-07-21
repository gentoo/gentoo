# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="Qt4 tag editor for mp3 files"
HOMEPAGE="http://www.qt-apps.org/content/show.php/QTagConvert2?content=100481"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/taglib"
RDEPEND="${DEPEND}"

DOCS=( README.utf8 )
PATCHES=( "${FILESDIR}/${P}-desktop.patch" )

src_prepare() {
	sed -e "/INSTALLS +=/s/documentation//" -i ${PN}.pro \
		|| die "failed to remove unneeded docs"

	qt4-r2_src_prepare
}
