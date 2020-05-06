# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.69.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Program that helps to learn and practice touch typing"
HOMEPAGE="https://kde.org/applications/education/org.kde.ktouch"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="X"

COMMON_DEPEND="
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libxcb[xkb]
		x11-libs/libxkbfile
	)
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/kqtquickcharts-${PVCUT}:5
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
"

src_configure() {
	local mycmakeargs=(
		-DCOMPILE_QML=OFF
		$(cmake_use_find_package X X11)
		$(cmake_use_find_package X Qt5X11Extras)
	)
	ecm_src_configure
}
