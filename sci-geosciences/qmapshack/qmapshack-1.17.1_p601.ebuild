# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://github.com/Maproom/qmapshack/wiki"
COMMIT="b53959a305587f0a7f2330b99267b3b24abb76f4"
SRC_URI="https://github.com/Maproom/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus"

RDEPEND="
	dev-db/sqlite
	>=dev-libs/quazip-1.3:0=[qt6]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[dbus,gui,network,sql,widgets,xml]
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

PATCHES=( "${FILESDIR}"/dbus-r1.patch )

src_configure() {
	local mycmakeargs=( -DUSE_QT6DBus=$(usex dbus) )
	cmake_src_configure
}

src_install() {
	docompress -x /usr/share/doc/${PF}/html
	cmake_src_install
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html || die "mv Qt help failed"
	ewarn "An experimental Qt6 port"
	ewarn "Translations and the help system are broken"
	ewarn "Other bugs to https://github.com/Maproom/qmapshack/issues"
}
