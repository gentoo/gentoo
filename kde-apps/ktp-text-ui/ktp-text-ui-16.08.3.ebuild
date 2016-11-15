# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="KDE Telepathy text chat window"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="Apache-2.0 || ( AFL-2.1 BSD ) GPL-2+ LGPL-2.1+ MIT"
KEYWORDS="~amd64 ~x86"
IUSE="speech"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdewebkit)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kpeople)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_kdeapps_dep ktp-common-internals otr)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	net-libs/telepathy-qt[qt5]
	speech? ( $(add_qt_dep qtspeech) )
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep ktp-contact-list)
	!kde-apps/ktp-text-ui:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
	)

	kde5_src_configure
}
