# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=56762d582d8a8543f50c293ff54d5ac5e546c2d9
KDE_HANDBOOK="forceoptional"
KDE_SELINUX_MODULE="games"
inherit kde5 vcs-snapshot

DESCRIPTION="Simple chess board based on KDE Frameworks"
HOMEPAGE="https://www.linux-apps.com/content/show.php/Knights?content=122046"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="speech"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
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
	!games-board/knights:4
"

pkg_postinst() {
	kde5_pkg_postinst

	elog "No chess engines are emerged by default! If you want a chess engine"
	elog "to play with, you can emerge gnuchess or crafty."
}
