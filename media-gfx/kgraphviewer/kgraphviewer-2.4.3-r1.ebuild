# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Graphviz dot graph file viewer"
HOMEPAGE="https://apps.kde.org/en/kgraphviewer"
[[ ${PV} != *9999* ]] && SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2 GPL-2+ LGPL-2+ LGPL-2.1+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=media-gfx/graphviz-2.30
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!media-gfx/kgraphviewer:4
"

PATCHES=( "${FILESDIR}/${P}-set-startupwmclass.patch" )
