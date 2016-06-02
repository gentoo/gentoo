# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime qmake-utils

DESCRIPTION="A feature rich chm file viewer, based on Qt"
HOMEPAGE="http://www.kchmviewer.net/"
SRC_URI="mirror://sourceforge/kchmviewer/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="qt5"

RDEPEND="
	dev-libs/chmlib
	dev-libs/libzip:=
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)

"
DEPEND="${RDEPEND}"

src_prepare() {
	# fix parallel build wrt bug #527192
	echo "src.depends = lib" >> ${PN}.pro || die
}

src_configure() {
	if use qt5; then
		eqmake5
	else
		eqmake4
	fi
}

src_install() {
	dodoc ChangeLog DBUS-bindings FAQ README
	doicon packages/kchmviewer.png

	dobin bin/kchmviewer
	domenu packages/kchmviewer.desktop

}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
