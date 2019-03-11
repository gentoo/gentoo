# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Music Education software by KDE"
HOMEPAGE="https://minuet.kde.org/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtquickcontrols2)
	media-sound/fluidsynth:=
"
RDEPEND="${DEPEND}"
