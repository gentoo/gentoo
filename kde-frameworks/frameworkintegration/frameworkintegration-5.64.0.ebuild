# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for integrating Qt applications with KDE Plasma workspaces"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="appstream X"

# drop qtwidgets subslot operator when QT_MINIMAL >= 5.14.0
DEPEND="
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kconfigwidgets-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kiconthemes-${PVCUT}:5
	>=kde-frameworks/knewstuff-${PVCUT}:5
	>=kde-frameworks/knotifications-${PVCUT}:5
	>=kde-frameworks/kpackage-${PVCUT}:5
	>=kde-frameworks/kwidgetsaddons-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5=
	appstream? (
		app-admin/packagekit-qt
		dev-libs/appstream[qt5]
	)
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb
	)
"
RDEPEND="${DEPEND}"

# requires running kde environment
RESTRICT+=" test"

src_prepare() {
	ecm_punt_bogus_dep Qt5 DBus
	ecm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package appstream AppStreamQt)
		$(cmake_use_find_package appstream packagekitqt5)
		$(cmake_use_find_package X XCB)
	)

	ecm_src_configure
}
