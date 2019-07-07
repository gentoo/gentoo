# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_SELINUX_MODULE="games"
inherit kde5

DESCRIPTION="Simple chess board based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/games/knights/"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="speech"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kplotting)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_kdeapps_dep libkdegames)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	speech? ( $(add_qt_dep qtspeech) )
"
RDEPEND="${DEPEND}
	|| (
		games-board/gnuchess
		games-board/crafty
		games-board/stockfish
		games-board/sjeng
	)
"
