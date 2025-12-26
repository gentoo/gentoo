# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.116.0
QTMIN=5.15.17
inherit ecm plasma.kde.org xdg

DESCRIPTION="Breeze visual style for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/breeze"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
"
RDEPEND="${DEPEND}
	!<${CATEGORY}/${PN}-6.5.2-r1:6[qt5]
	>=${CATEGORY}/${PN}-6.5.0:6[-qt5(-)]
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"
PDEPEND=">=kde-frameworks/breeze-icons-${KFMIN}:*"

ECM_REMOVE_FROM_INSTALL=( /usr/share/kstyle/themes/breeze.themerc )

src_prepare() {
	ecm_src_prepare
	cmake_comment_add_subdirectory colors
	cmake_comment_add_subdirectory cursors
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_QT6=OFF
		-DBUILD_QT5=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5FrameworkIntegration=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5X11Extras=ON
	)
	ecm_src_configure
}
