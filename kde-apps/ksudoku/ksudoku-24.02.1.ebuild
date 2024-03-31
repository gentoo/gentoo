# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Logic-based symbol placement puzzle by KDE"
HOMEPAGE="https://apps.kde.org/ksudoku/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE="opengl"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,opengl?,widgets,xml]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-apps/libkdegames-${PVCUT}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	opengl? (
		media-libs/libglvnd
		virtual/glu
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package opengl Qt6OpenGL)
		$(cmake_use_find_package opengl OpenGL)
	)
	ecm_src_configure
}
