# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Game based on anagrams of words"
HOMEPAGE="https://www.kde.org/applications/education/kanagram https://edu.kde.org/kanagram/"
KEYWORDS="~amd64 ~x86"
IUSE="speech"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_kdeapps_dep libkeduvocdocument)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	media-libs/phonon[qt5(+)]
	speech? ( $(add_qt_dep qtspeech) )
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdeedu-data)
	$(add_qt_dep qtmultimedia 'qml')
	$(add_qt_dep qtquickcontrols)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
	)

	kde5_src_configure
}
