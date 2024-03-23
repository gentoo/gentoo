# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing additional format plugins for Qt's image I/O system"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE="avif eps heif jpegxl openexr raw"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	=kde-frameworks/karchive-${PVCUT}*:6
	avif? ( >=media-libs/libavif-0.8.2:= )
	eps? ( >=dev-qt/qtbase-${QTMIN}:6[widgets] )
	heif? ( >=media-libs/libheif-1.10.0:= )
	jpegxl? ( >=media-libs/libjxl-0.7.0:= )
	openexr? ( >=media-libs/openexr-3:= )
	raw? ( media-libs/libraw:= )
"
DEPEND="${RDEPEND}
	test? (
		>=dev-qt/qtimageformats-${QTMIN}:6
		heif? ( media-libs/libheif[x265] )
	)
"

DOCS=( src/imageformats/AUTHORS )

src_configure() {
	local mycmakeargs=(
		-DKIMAGEFORMATS_JXL=$(usex jpegxl)
		$(cmake_use_find_package avif libavif)
		$(cmake_use_find_package eps Qt6PrintSupport)
		-DKIMAGEFORMATS_HEIF=$(usex heif)
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package raw LibRaw)
	)
	ecm_src_configure
}
