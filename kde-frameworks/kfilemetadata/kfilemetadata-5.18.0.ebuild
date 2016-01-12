# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Library for extracting file metadata"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="epub exif ffmpeg libav pdf taglib"

# TODO: mobi? ( $(add_plasma_dep kdegraphics-mobipocket) ) NOTE: not integrated upstream
DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep ki18n)
	dev-qt/qtxml:5
	epub? ( app-text/ebook-tools )
	exif? ( media-gfx/exiv2:= )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	pdf? ( app-text/poppler[qt5] )
	taglib? ( media-libs/taglib )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package epub EPub)
		$(cmake-utils_use_find_package exif Exiv2)
		$(cmake-utils_use_find_package ffmpeg FFmpeg)
		$(cmake-utils_use_find_package pdf PopplerQt5)
		$(cmake-utils_use_find_package taglib Taglib)
	)

	kde5_src_configure
}
