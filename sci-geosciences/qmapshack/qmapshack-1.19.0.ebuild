# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://github.com/Maproom/qmapshack/wiki"
SRC_URI="https://github.com/Maproom/${PN}/archive/tags/V_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-tags-V_${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="dbus"

RDEPEND="
	dev-db/sqlite
	>=dev-libs/quazip-1.3-r2:=[qt6(+)]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[dbus?,gui,network,sql,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qttools:6[assistant,widgets]
	dev-qt/qtwebengine:6[widgets]
	sci-geosciences/routino
	sci-libs/alglib
	sci-libs/gdal:=
	sci-libs/proj:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT6DBus=$(usex dbus)
		-DHTML_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}/qch"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	docompress -x "/usr/share/doc/${PF}/qch"
}
