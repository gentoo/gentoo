# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing additional format plugins for Qt's image I/O system"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="eps openexr"

DEPEND="
	>=kde-frameworks/karchive-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	eps? ( >=dev-qt/qtprintsupport-${QTMIN}:5 )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
"
RDEPEND="${DEPEND}"

DOCS=( src/imageformats/AUTHORS )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package eps Qt5PrintSupport)
		$(cmake_use_find_package openexr OpenEXR)
	)

	ecm_src_configure
}
