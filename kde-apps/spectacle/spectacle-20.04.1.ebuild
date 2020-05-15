# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.70.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Screenshot capture utility"
HOMEPAGE="https://kde.org/applications/utilities/org.kde.spectacle"

LICENSE="LGPL-2+ handbook? ( FDL-1.3 ) kipi? ( GPL-2+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="kipi share"

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=dev-qt/qdbus-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	kipi? ( >=kde-apps/libkipi-${PVCUT}:5= )
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
"
RDEPEND="${DEPEND}
	kipi? ( >=kde-apps/kipi-plugins-${PVCUT}:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kipi KF5Kipi)
		$(cmake_use_find_package share KF5Purpose)
	)
	ecm_src_configure
}
