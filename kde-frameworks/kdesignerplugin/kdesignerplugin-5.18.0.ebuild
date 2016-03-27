# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework providing plugins to use KDE frameworks widgets in QtDesigner"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm ~x86"
IUSE="designer nls webkit"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	designer? (
		dev-qt/designer:5
		$(add_frameworks_dep kcompletion)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep kiconthemes)
		$(add_frameworks_dep kio)
		$(add_frameworks_dep kitemviews)
		$(add_frameworks_dep kplotting)
		$(add_frameworks_dep ktextwidgets)
		$(add_frameworks_dep kwidgetsaddons)
		$(add_frameworks_dep kxmlgui)
		$(add_frameworks_dep sonnet)
	)
	webkit? (
		dev-qt/designer:5
		dev-qt/qtgui:5
		$(add_frameworks_dep kdewebkit)
	)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kdoctools)
	nls? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package designer KF5IconThemes)
		$(cmake-utils_use_find_package designer KF5ItemViews)
		$(cmake-utils_use_find_package designer KF5KIO)
		$(cmake-utils_use_find_package designer KF5Plotting)
		$(cmake-utils_use_find_package designer KF5TextWidgets)
		$(cmake-utils_use_find_package designer KF5WidgetsAddons)
		$(cmake-utils_use_find_package webkit KF5WebKit)
	)

	kde5_src_configure
}
