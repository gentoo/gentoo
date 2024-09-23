# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://github.com/Maproom/qmapshack/wiki"
COMMIT="1f009ac0be1d1c2a4c31aa1283f4009e88685d34"
SRC_URI="https://github.com/kiozen/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

PATCHES=( "${FILESDIR}"/dbus.patch )

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
