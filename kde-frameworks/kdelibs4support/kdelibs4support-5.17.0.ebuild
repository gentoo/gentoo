# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework easing the development transition from KDE 4 to KF 5"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="X"

COMMON_DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdesignerplugin)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kunitconversion)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	app-text/docbook-xml-dtd:4.2
	dev-libs/openssl:0
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	virtual/libintl
	X? (
		dev-qt/qtx11extras:5
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
	)
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kdoctools)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kitemmodels)
	dev-qt/qtxml:5
	!<kde-apps/kcontrol-15.08.0[handbook]
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kdoctools)
	dev-lang/perl
	dev-perl/URI
	dev-qt/designer:5
	test? ( dev-qt/qtconcurrent:5 )
	X? ( x11-proto/xproto )
"

RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
