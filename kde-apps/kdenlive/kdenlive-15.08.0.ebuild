# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
KDE_PUNT_BOGUS_DEPS="true"
inherit kde5

DESCRIPTION="Non-linear video editing suite by KDE"
HOMEPAGE="http://www.kdenlive.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="v4l"

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
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
	$(add_frameworks_dep kplotting)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtscript:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=media-libs/mlt-0.9.8[ffmpeg,-kde,kdenlive,melt,-qt4,sdl,xml]
	virtual/ffmpeg[encode,sdl,X]
	virtual/opengl
	v4l? ( media-libs/libv4l )
	!media-video/kdenlive
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package v4l LibV4L2)
	)

	kde5_src_configure
}
