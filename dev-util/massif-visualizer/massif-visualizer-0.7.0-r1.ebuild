# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Tool visualising massif data"
HOMEPAGE="https://apps.kde.org/en/massif-visualizer"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="5"
KEYWORDS="~amd64"
IUSE="+callgraph"

RDEPEND="
	dev-libs/kdiagram:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	callgraph? ( media-gfx/kgraphviewer:5 )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
"

PATCHES=( "${FILESDIR}/${P}-fix-window-icon.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package callgraph KGraphViewerPart)
	)
	ecm_src_configure
}
