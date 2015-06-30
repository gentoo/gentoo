# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/ksysguard/ksysguard-5.3.2.ebuild,v 1.1 2015/06/30 20:50:15 johu Exp $

EAPI=5

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Network-enabled task manager and system monitor"
LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE="lm_sensors"

DEPEND="
	$(add_plasma_dep libksysguard processui)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	lm_sensors? ( sys-apps/lm_sensors )
"
RDEPEND="${DEPEND}
	!kde-base/ksysguard
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package lm_sensors Sensors)
	)

	kde5_src_configure
}
