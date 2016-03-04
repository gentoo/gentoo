# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Extra Plasma applets and engines"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ibus scim"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kross)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kunitconversion)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	ibus? (
		app-i18n/ibus
		dev-libs/glib:2
		$(add_qt_dep qtx11extras)
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
	scim? ( app-i18n/scim )
"
RDEPEND="${DEPEND}
	$(add_plasma_dep plasma-workspace)
	!kde-base/kdeplasma-addons:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package ibus IBus)
		$(cmake-utils_use_find_package scim SCIM)
	)

	kde5_src_configure
}
