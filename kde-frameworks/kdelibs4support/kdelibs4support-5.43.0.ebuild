# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_QTHELP="false"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework easing the development transition from KDELibs 4 to KF 5"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="libressl X"

COMMON_DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kded)
	$(add_frameworks_dep kdesignerplugin)
	$(add_frameworks_dep kemoticons)
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
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork 'ssl')
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qttest)
	$(add_qt_dep qtwidgets)
	app-text/docbook-xml-dtd:4.2
	virtual/libintl
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kdoctools)
	$(add_qt_dep designer)
	dev-lang/perl
	dev-perl/URI
	test? ( $(add_qt_dep qtconcurrent) )
	X? ( x11-proto/xproto )
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kdoctools)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kitemmodels)
	$(add_qt_dep qtxml)
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
