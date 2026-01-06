# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.16.0
QTMIN=6.9.3
inherit ecm kde.org xdg

DESCRIPTION="Project management application"
HOMEPAGE="https://calligra.org/components/plan/"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/stable/calligraplan/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="activities +holidays kwallet"

# not wired up between upstream's CMake and code:
# https://invent.kde.org/office/calligraplan/-/issues/5
# IUSE="X" ... X? ( x11-libs/libX11 )
DEPEND="
	dev-lang/perl
	>=dev-libs/kdiagram-3.0.1:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=dev-qt/qttools-${QTMIN}:6[designer]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	activities? ( kde-plasma/plasma-activities:6 )
	holidays? ( >=kde-frameworks/kholidays-${KFMIN}:6 )
	kwallet? (
		>=app-crypt/qca-2.3.7:2[qt6(+)]
		>=kde-frameworks/kwallet-${KFMIN}:6
	)
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
"

PATCHES=( "${FILESDIR}/${P}-version.patch" )

CMAKE_SKIP_TESTS=( plan-schedulers-tj-TaskJugglerTester ) # segfaults/permissions

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities PlasmaActivities)
		$(cmake_use_find_package holidays KF6Holidays)
		$(cmake_use_find_package kwallet Qca-qt6)
		$(cmake_use_find_package kwallet KF6Wallet)
	)
	# Qt6DBus can't be disabled because of KF6DBusAddons dependency

	ecm_src_configure
}
