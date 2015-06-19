# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfilemetadata/kfilemetadata-4.14.3.ebuild,v 1.6 2015/06/04 18:43:51 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A library for extracting file metadata"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug epub exif ffmpeg mobi pdf taglib"

DEPEND="
	epub? ( app-text/ebook-tools )
	exif? ( media-gfx/exiv2:= )
	ffmpeg? ( virtual/ffmpeg )
	mobi? ( $(add_kdeapps_dep kdegraphics-mobipocket) )
	pdf? ( app-text/poppler[qt4] )
	taglib? ( media-libs/taglib )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package epub EPub)
		$(cmake-utils_use_find_package exif Exiv2)
		$(cmake-utils_use_find_package ffmpeg FFmpeg)
		$(cmake-utils_use_find_package mobi QMobipocket)
		$(cmake-utils_use_find_package pdf PopplerQt4)
		$(cmake-utils_use_find_package taglib Taglib)
	)

	kde4-base_src_configure
}
