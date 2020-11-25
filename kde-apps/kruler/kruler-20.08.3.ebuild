# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.74.0
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="Screen ruler for Plasma"
HOMEPAGE="https://apps.kde.org/en/kruler"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="X"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
