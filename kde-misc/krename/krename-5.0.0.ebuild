# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Powerful batch file renamer"
HOMEPAGE="http://www.krename.net/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="exif pdf taglib truetype"

COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kjs)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	exif? ( media-gfx/exiv2:= )
	pdf? ( app-text/podofo )
	taglib? ( media-libs/taglib )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	!kde-misc/krename:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package exif Exiv2)
		$(cmake-utils_use_find_package taglib Taglib)
		$(cmake-utils_use_find_package pdf PoDoFo)
		$(cmake-utils_use_find_package truetype Freetype)
	)

	kde5_src_configure
}
