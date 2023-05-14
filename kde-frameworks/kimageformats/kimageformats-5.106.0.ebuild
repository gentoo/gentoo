# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing additional format plugins for Qt's image I/O system"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="avif eps heif jpegxl openexr raw"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	avif? ( >=media-libs/libavif-0.8.2:= )
	eps? ( >=dev-qt/qtprintsupport-${QTMIN}:5 )
	heif? ( >=media-libs/libheif-1.10.0:= )
	jpegxl? ( media-libs/libjxl )
	openexr? ( >=media-libs/openexr-3:= )
	raw? ( media-libs/libraw:= )
"
DEPEND="${RDEPEND}
	test? ( heif? ( media-libs/libheif[x265] ) )
"

DOCS=( src/imageformats/AUTHORS )

src_configure() {
	local mycmakeargs=(
		-DKIMAGEFORMATS_JXL=$(usex jpegxl)
		$(cmake_use_find_package avif libavif)
		$(cmake_use_find_package eps Qt5PrintSupport)
		-DKIMAGEFORMATS_HEIF=$(usex heif)
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package raw LibRaw)
	)
	ecm_src_configure
}
