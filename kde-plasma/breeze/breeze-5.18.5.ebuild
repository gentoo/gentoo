# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Breeze visual style for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/breeze"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="wayland X"

# drop qtwidgets subslot operator when QT_MINIMAL >= 5.13.0
RDEPEND="
	>=kde-frameworks/frameworkintegration-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/kdecoration-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5=
	sci-libs/fftw:3.0=
	wayland? ( >=kde-frameworks/kwayland-${KFMIN}:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kpackage-${KFMIN}:5
"
PDEPEND="
	>=kde-frameworks/breeze-icons-${KFMIN}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package wayland KF5Wayland)
		$(cmake_use_find_package X XCB)
	)
	ecm_src_configure
}
