# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Qt Based WhatsApp Client"
HOMEPAGE="https://github.com/keshavbhatt/whatsie"
SRC_URI="https://github.com/keshavbhatt/whatsie/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"

QT_MIN="5.15"

DEPEND="
	x11-libs/libX11
	x11-libs/libxcb:=
	>=dev-qt/qtcore-${QT_MIN}:5
	>=dev-qt/qtgui-${QT_MIN}:5
	>=dev-qt/qtnetwork-${QT_MIN}:5
	>=dev-qt/qtpositioning-${QT_MIN}:5
	>=dev-qt/qtwebengine-${QT_MIN}:5[widgets]
	>=dev-qt/qtwidgets-${QT_MIN}:5
"

RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	einstalldocs
	INSTALL_ROOT="${ED}" emake install
}
