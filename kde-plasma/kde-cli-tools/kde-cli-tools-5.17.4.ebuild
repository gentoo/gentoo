# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
VIRTUALX_REQUIRED="test"
KFMIN=5.64.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Tools based on KDE Frameworks 5 to better interact with the system"
HOMEPAGE="https://cgit.kde.org/kde-cli-tools.git"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="kdesu X"

REQUIRED_USE="kdesu? ( X )"

DEPEND="
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/libkworkspace-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	kdesu? ( >=kde-frameworks/kdesu-${KFMIN}:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
"
RDEPEND="${DEPEND}
	kdesu? ( sys-apps/dbus[X] )
"

PATCHES=( "${FILESDIR}/${PN}-5.12.80-tests-optional.patch" )

# requires running kde environment
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kdesu KF5Su)
		$(cmake_use_find_package X Qt5X11Extras)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install
	use kdesu && dosym ../$(get_libdir)/libexec/kf5/kdesu /usr/bin/kdesu
}
