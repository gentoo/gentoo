# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Tool for indexing, searching, and viewing images"
HOMEPAGE="https://www.kphotoalbum.org/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2+ FDL-1.2"
IUSE="+kipi map +raw"

DEPEND="
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
RDEPEND="${DEPEND}
	media-video/ffmpeg
	kipi? ( kde-apps/kipi-plugins:5 )
"

DOCS=( ChangeLog README.md )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kipi KF5Kipi)
		$(cmake_use_find_package map KF5KGeoMap)
		$(cmake_use_find_package raw KF5KDcraw)
	)

	kde5_src_configure
}
