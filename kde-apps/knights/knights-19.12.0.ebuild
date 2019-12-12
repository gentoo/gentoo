# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KDE_SELINUX_MODULE="games"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Simple chess board based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/games/org.kde.knights"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="speech"

DEPEND="
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kplotting-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-apps/libkdegames-${PVCUT}:5
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
"
RDEPEND="${DEPEND}
	|| (
		games-board/gnuchess
		games-board/crafty
		games-board/stockfish
		games-board/sjeng
	)
"
