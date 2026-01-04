# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=uChmViewer
inherit cmake xdg

DESCRIPTION="Feature rich chm file viewer, based on Qt"
HOMEPAGE="https://github.com/eBookProjects/uChmViewer"
SRC_URI="https://github.com/eBookProjects/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-libs/chmlib
	dev-libs/libzip:=
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[dbus,gui,network,widgets,xml]
	dev-qt/qtwebengine:6[widgets]
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS.md ChangeLog DBUS-bindings README.md )

src_configure() {
	local mycmakeargs=(
		-DAPP_QT_VERSION=6
		-DUSE_DBUS=ON
		-DUSE_GETTEXT=ON
		-DUSE_WEBENGINE=ON
	)
	cmake_src_configure
}
