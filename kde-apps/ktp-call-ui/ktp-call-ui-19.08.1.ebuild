# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="KDE Telepathy audio/video conferencing ui"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep ktp-common-internals)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/glib:2
	media-libs/phonon[qt5(+)]
	media-libs/qt-gstreamer[qt5(+)]
	net-libs/farstream:0.2
	net-libs/telepathy-farstream
	net-libs/telepathy-qt[farstream,qt5(+)]
"
# TODO: dep leak suspect
DEPEND="${RDEPEND}
	$(add_frameworks_dep kcmutils)
"
