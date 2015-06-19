# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/picturewall/picturewall-1.0-r1.ebuild,v 1.5 2013/03/02 21:39:27 hwoarang Exp $

EAPI=4

inherit eutils qt4-r2

MY_PN="PictureWall"

DESCRIPTION="Qt4 picture viewer and image searching tool using google.com"
HOMEPAGE="http://www.qt-apps.org/content/show.php?content=106101"
SRC_URI="http://picturewall.googlecode.com/files/${MY_PN}_${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc"

RDEPEND=">=dev-qt/qtcore-4.5.3:4
	>=dev-qt/qtgui-4.5.3:4
	>=dev-qt/qtwebkit-4.5.3:4"
DEPEND="app-arch/unzip
	${RDEPEND}"

S=${WORKDIR}/${MY_PN}/${MY_PN}

src_install(){
	dobin bin/${PN}
	dodoc ReadMe
	use doc && dohtml -r doc/html/*
	make_desktop_entry ${PN} ${MY_PN}
}
