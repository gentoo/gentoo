# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.116.0
QTMIN=5.15.17
inherit ecm plasma.kde.org xdg

DESCRIPTION="Oxygen visual style for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/oxygen"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="X"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/frameworkintegration-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb
	)
"
RDEPEND="${COMMON_DEPEND}
	!<${CATEGORY}/${PN}-6.5.2-r1:6[qt5]
	>=${CATEGORY}/${PN}-6.5.0:6[-qt5(-)]
	!<kde-plasma/libplasma-6.1.90:*[-kf6compat(-)]
"

ECM_REMOVE_FROM_INSTALL=( /usr/share/kstyle/themes/oxygen.themerc )

src_prepare() {
	ecm_src_prepare
	cmake_comment_add_subdirectory color-schemes
	cmake_comment_add_subdirectory cursors
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_QT6=OFF
		-DBUILD_QT5=ON
		$(cmake_use_find_package X XCB)
	)
	ecm_src_configure
}
