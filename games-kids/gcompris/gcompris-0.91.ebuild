# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop

DESCRIPTION="full featured educational application for children from 2 to 10"
HOMEPAGE="https://gcompris.net/"
SRC_URI="http://gcompris.net/download/qt/src/gcompris-qt-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-qt-${PV}"

RDEPEND="
	dev-qt/qtcore
	dev-qt/qtgraphicaleffects
	dev-qt/qtgui
	dev-qt/qtmultimedia[qml]
	dev-qt/qtnetwork
	dev-qt/qtquickcontrols
	dev-qt/qtsensors[qml]
	dev-qt/qtsvg
	dev-qt/qtxml
	dev-qt/qtxmlpatterns"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools"

src_configure() {
	local mycmakeargs=(
		# TODO: add box2d support
		-DQML_BOX2D_MODULE=disabled
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	domenu org.kde.gcompris.desktop
}
