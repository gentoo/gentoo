# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/kfilemetadata/kfilemetadata-5.9.2.ebuild,v 1.1 2015/06/30 20:50:14 johu Exp $

EAPI=5

KDE_TEST="true"
inherit kde5

# version scheme fail by upstream
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	PLASMA_VERSION=5.3.2
	SRC_URI="mirror://kde/stable/plasma/${PLASMA_VERSION}/${PN}-${PV}.tar.xz"
fi

DESCRIPTION="Library for extracting file metadata"
KEYWORDS=" ~amd64"
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
RDEPEND="${DEPEND}
	!kde-base/kfilemetadata:5
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
