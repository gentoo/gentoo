# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing additional format plugins for Qt's image I/O system"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="avif eps heif openexr"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	avif? ( >=media-libs/libavif-0.8.2 )
	eps? ( >=dev-qt/qtprintsupport-${QTMIN}:5 )
	heif? ( >=media-libs/libheif-1.10.0:= )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
"
RDEPEND="${DEPEND}"

DOCS=( src/imageformats/AUTHORS )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package avif libavif)
		$(cmake_use_find_package eps Qt5PrintSupport)
		-DKIMAGEFORMATS_HEIF=$(usex heif)
		$(cmake_use_find_package openexr OpenEXR)
	)

	ecm_src_configure
}
