# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit flag-o-matic kde5

DESCRIPTION="Tool for indexing, searching, and viewing images"
HOMEPAGE="https://www.kphotoalbum.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2+ FDL-1.2"
KEYWORDS="amd64 x86"
IUSE="+kipi +map +raw"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql 'sqlite')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	media-gfx/exiv2:=
	media-libs/phonon[qt5(+)]
	virtual/jpeg:0
	kipi? ( $(add_kdeapps_dep libkipi) )
	map? ( $(add_kdeapps_dep libkgeomap) )
	raw? ( $(add_kdeapps_dep libkdcraw) )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	media-video/mplayer
	kipi? ( media-plugins/kipi-plugins:5 )
	!media-gfx/kphotoalbum:4
"

DOCS=( ChangeLog README )

PATCHES=( "${FILESDIR}/${P}-gcc8.patch" )

src_configure() {
	append-ldflags -fuse-ld=gold #bug #623566

	local mycmakeargs=(
		$(cmake-utils_use_find_package kipi KF5Kipi)
		$(cmake-utils_use_find_package map KF5KGeoMap)
		$(cmake-utils_use_find_package raw KF5KDcraw)
	)

	kde5_src_configure
}
