# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

ASMJIT_GIT_TAG="0bd5787b54b575ed94bf32ac452153b34385c514"
BLEND2D_GIT_TAG="def0d1238c3e5d0983bb848e5676049d829e435b"

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://github.com/Maproom/qmapshack/wiki"
SRC_URI="
	https://github.com/Maproom/${PN}/archive/refs/tags/V_${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/asmjit/asmjit/archive/${ASMJIT_GIT_TAG}.tar.gz -> asmjit-${ASMJIT_GIT_TAG}.tar.gz
	https://github.com/blend2d/blend2d/archive/${BLEND2D_GIT_TAG}.tar.gz -> blend2d-${BLEND2D_GIT_TAG}.tar.gz
"
S="${WORKDIR}"/${PN}-V_${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus"

RDEPEND="
	dev-db/sqlite
	>=dev-libs/quazip-1.3-r2:=[qt6(+)]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[dbus?,gui,network,sql,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6[assistant,widgets]
	dev-qt/qtwebengine:6[widgets]
	sci-geosciences/routino
	sci-libs/alglib
	>=sci-libs/gdal-3.10.0:=
	>=sci-libs/proj-9.4.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	grep -qe "ASMJIT_GIT_TAG.*${ASMJIT_GIT_TAG}" "${S}/CMakeLists.txt" || die
	grep -qe "BLEND2D_GIT_TAG.*${BLEND2D_GIT_TAG}" "${S}/CMakeLists.txt" || die
	local mycmakeargs=(
		-DUSE_QT6DBus=$(usex dbus)
		-DHTML_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}/qch"
		-DFETCHCONTENT_SOURCE_DIR_ASMJIT="${WORKDIR}/asmjit-${ASMJIT_GIT_TAG}"
		-DFETCHCONTENT_SOURCE_DIR_BLEND2D="${WORKDIR}/blend2d-${BLEND2D_GIT_TAG}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	docompress -x "/usr/share/doc/${PF}/qch"
}
