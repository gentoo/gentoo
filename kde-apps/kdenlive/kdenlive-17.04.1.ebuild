# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="Non-linear video editing suite by KDE"
HOMEPAGE="https://www.kdenlive.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="freesound gles2 jogshuttle semantic-desktop v4l"

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui 'gles2=')
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=media-libs/mlt-6.0.0[ffmpeg,kdenlive,melt,qt5,sdl,xml]
	virtual/ffmpeg[encode,sdl,X]
	virtual/opengl
	freesound? ( $(add_qt_dep qtwebkit) )
	semantic-desktop? ( $(add_frameworks_dep kfilemetadata) )
	v4l? ( media-libs/libv4l )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package freesound Qt5WebKitWidgets)
		-DWITH_JogShuttle=$(usex jogshuttle)
		$(cmake-utils_use_find_package semantic-desktop KF5FileMetaData)
		$(cmake-utils_use_find_package v4l LibV4L2)
	)

	kde5_src_configure
}
