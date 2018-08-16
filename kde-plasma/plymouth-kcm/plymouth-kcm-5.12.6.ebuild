# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BOGUS=1
inherit kde5

DESCRIPTION="KDE Plasma control module for Plymouth"
HOMEPAGE="https://cgit.kde.org/plymouth-kcm.git"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtwidgets)
	sys-boot/plymouth
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
"

DOCS=( CONTRIBUTORS )
