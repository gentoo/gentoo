# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="317b1e70a87224c94cac85955a3d666a43527812"
ECM_HANDBOOK="optional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="The japanese warehouse keeper game"
HOMEPAGE="https://invent.kde.org/games/ksokoban"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kiconthemes-${KFMIN}:5
"

S="${WORKDIR}/${PN}-${COMMIT}"
