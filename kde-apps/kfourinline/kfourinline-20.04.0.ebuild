# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.69.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE four-in-a-row game"
HOMEPAGE="https://kde.org/applications/games/org.kde.kfourinline
https://games.kde.org/game.php?game=kfourinline"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-apps/libkdegames-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"
