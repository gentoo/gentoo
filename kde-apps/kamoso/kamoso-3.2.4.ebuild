# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5 versionator

DESCRIPTION="Application to take pictures and videos from your webcam by KDE"
HOMEPAGE="https://userbase.kde.org/Kamoso"
SRC_URI="mirror://kde/stable/${PN}/$(get_version_component_range 1-2)/src/${P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	kde-frameworks/purpose:5
	media-libs/qt-gstreamer[qt5(+)]
	virtual/libudev:=
"
RDEPEND="${DEPEND}
	media-plugins/gst-plugins-meta:1.0[alsa,theora,vorbis,v4l]
"
