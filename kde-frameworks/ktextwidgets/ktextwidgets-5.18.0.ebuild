# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing an assortment of widgets for displaying and editing text"
LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="speech"

RDEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep sonnet)
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	speech? ( dev-qt/qtspeech:5 )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
	)

	kde5_src_configure
}
