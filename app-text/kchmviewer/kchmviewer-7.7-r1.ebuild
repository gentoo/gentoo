# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils

DESCRIPTION="Feature rich chm file viewer, based on Qt"
HOMEPAGE="https://www.ulduzsoft.com/kchmviewer/"
SRC_URI="mirror://sourceforge/kchmviewer/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
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
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-force-qtwebkit.patch"
	"${FILESDIR}/${P}-underlinking.patch"
)

src_configure() {
	eqmake5
}

src_install() {
	dodoc ChangeLog DBUS-bindings FAQ README
	doicon packages/kchmviewer.png
	dobin bin/kchmviewer
	domenu packages/kchmviewer.desktop
}
