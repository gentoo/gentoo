# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KFMIN=5.99.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm plasma.kde.org

DESCRIPTION="Tools based on KDE Frameworks 5 to better interact with the system"
HOMEPAGE="https://invent.kde.org/plasma/kde-cli-tools"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv"
IUSE="kdesu X"

REQUIRED_USE="kdesu? ( X )"
# requires running kde environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/libkworkspace-${PVCUT}:5
	kdesu? ( >=kde-frameworks/kdesu-${KFMIN}:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
"
RDEPEND="${DEPEND}
	kdesu? ( sys-apps/dbus[X] )
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"

PATCHES=( "${FILESDIR}/${PN}-5.12.80-tests-optional.patch" )

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
