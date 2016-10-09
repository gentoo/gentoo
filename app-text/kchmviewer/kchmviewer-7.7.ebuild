# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit fdo-mime qmake-utils

DESCRIPTION="Feature rich chm file viewer, based on Qt"
HOMEPAGE="http://www.kchmviewer.net/"
SRC_URI="mirror://sourceforge/kchmviewer/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/chmlib
	dev-libs/libzip:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-force-qtwebkit.patch"
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	# bug #579430
	sed -i \
		-e "s:zip:zip;:g" \
		packages/kchmviewer.desktop || die "Failed to fix desktop file"

	default
}

src_configure() {
	eqmake5
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
