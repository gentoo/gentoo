# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KDE_ORG_COMMIT="39b9d1c1702a21a6e0fae82876c29c1f6bb77fae"
MY_P="ksokoban-${PV}-${KDE_ORG_COMMIT:0:8}"
KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="The Japanese warehouse keeper sokoban game"
HOMEPAGE="https://invent.kde.org/games/skladnik"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

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
DEPEND="${RDEPEND}"
