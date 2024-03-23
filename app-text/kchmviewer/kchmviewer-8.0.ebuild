# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="Feature rich chm file viewer, based on Qt"
HOMEPAGE="https://www.ulduzsoft.com/kchmviewer/"
SRC_URI="https://github.com/gyunaev/${PN}/archive/refs/tags/RELEASE_${PV/./_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/kchmviewer-RELEASE_8_0"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	dev-libs/chmlib
	dev-libs/libzip:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-underlinking.patch"
	"${FILESDIR}/${P}-custom-url-scheme-registration.patch"
	"${FILESDIR}/${P}-no-qtwebkit.patch"
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
