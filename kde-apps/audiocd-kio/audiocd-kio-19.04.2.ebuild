# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="kioslave for accessing audio CDs"
LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="flac vorbis"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_kdeapps_dep libkcddb)
	$(add_kdeapps_dep libkcompactdisc)
	$(add_qt_dep qtwidgets)
	media-sound/cdparanoia
	flac? ( >=media-libs/flac-1.1.2 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-19.04.0-handbook.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package flac FLAC)
		$(cmake-utils_use_find_package vorbis OggVorbis)
	)

	kde5_src_configure
}
