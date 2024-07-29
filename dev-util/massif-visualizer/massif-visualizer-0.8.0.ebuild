# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.1.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Tool visualising massif data"
HOMEPAGE="https://apps.kde.org/massif-visualizer/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="+callgraph"

DEPEND="
	dev-libs/kdiagram:6
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	callgraph? ( >=media-gfx/kgraphviewer-2.5.0:0 )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package callgraph KGraphViewerPart)
	)
	ecm_src_configure
}
