# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils kde5

DESCRIPTION="Library for extracting file metadata"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="epub exif ffmpeg libav pdf taglib"

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtxml)
	epub? ( app-text/ebook-tools )
	exif? ( media-gfx/exiv2:= )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	pdf? ( app-text/poppler[qt5] )
	taglib? ( media-libs/taglib )
"
DEPEND="${RDEPEND}
	kernel_linux? ( sys-apps/attr )
"

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

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version app-text/catdoc || ! has_version dev-libs/libxls; then
		elog "To get additional features, optional runtime dependencies may be installed:"
		optfeature "indexing of Microsoft Word or Powerpoint files" app-text/catdoc
		optfeature "indexing of Microsoft Excel files" dev-libs/libxls
	fi
}
