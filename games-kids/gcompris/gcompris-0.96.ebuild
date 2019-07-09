# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop

DESCRIPTION="full featured educational application for children from 2 to 10"
HOMEPAGE="https://gcompris.net/"
SRC_URI="https://gcompris.net/download/qt/src/gcompris-qt-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[qml]
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtsensors:5[qml]
	dev-qt/qtsvg:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-qt-${PV}"

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
