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

RDEPEND="
	dev-db/sqlite
	>=dev-libs/quazip-1.3:0=[qt6]
	dev-qt/qt5compat:6[icu,qml]
	dev-qt/qtbase[dbus,gui,icu,network,opengl,sql,widgets,xml]
	dev-qt/qttools:6[assistant,linguist,opengl,qdbus,qml,widgets,zstd]
	dev-qt/qtwebengine:6[qml,widgets]
	sci-geosciences/routino
	sci-libs/alglib
	sci-libs/gdal:=
	sci-libs/proj:=
"
DEPEND="${RDEPEND}"

src_install() {
	docompress -x /usr/share/doc/${PF}/html
	cmake_src_install
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html || die "mv Qt help failed"
	ewarn "An experimental Qt6 port"
	ewarn "Translations and the help system are broken"
	ewarn "Other bugs to https://github.com/Maproom/qmapshack/issues"
}
