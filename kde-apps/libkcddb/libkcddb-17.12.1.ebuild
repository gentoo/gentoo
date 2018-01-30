# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4="false"
KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
inherit kde5

DESCRIPTION="KDE library for CDDB"
LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~x86"
IUSE="musicbrainz"

# tests require network access and compare static data with online data
# bug 280996
RESTRICT+=" test"

DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	musicbrainz? ( media-libs/musicbrainz:5 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	kde5_src_prepare

	if ! use handbook ; then
		pushd kcmcddb > /dev/null
		cmake_comment_add_subdirectory doc
		popd > /dev/null
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package musicbrainz MusicBrainz5)
	)

	kde5_src_configure
}
