# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.99.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.5
inherit ecm plasma.kde.org

DESCRIPTION="Breeze visual style for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/breeze"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
IUSE="X"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/frameworkintegration-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/kdecoration-${PVCUT}:5
	X? ( x11-libs/libxcb )
"
DEPEND="${RDEPEND}"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"
PDEPEND="
	>=kde-frameworks/breeze-icons-${KFMIN}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X XCB)
	)
	ecm_src_configure
}
