# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C/C++ library for manipulating the LAS LiDAR format common in GIS"
HOMEPAGE="http://www.liblas.org"
SRC_URI="http://download.osgeo.org/${PN}/libLAS-${PV}.tar.bz2"

# tests known to fail due to LD_LIBRARY_PATH issue
RESTRICT="test"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"
IUSE="gdal"

RDEPEND="
	dev-libs/boost:=
	sci-geosciences/laszip
	sci-libs/libgeotiff
	gdal? ( sci-libs/gdal )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libLAS-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.0_remove-std-c++98.patch
)

src_prepare() {
	cmake-utils_src_prepare

	# add missing linkage
	sed -e 's:${LAS2COL} ${LIBLAS_C_LIB_NAME}:& ${CMAKE_THREAD_LIBS_INIT}:' \
		-i "${S}/apps/CMakeLists.txt" || die
}

src_configure() {
	local mycmakeargs=(
		"-DWITH_GDAL=$(usex gdal)"
		-DLIBLAS_LIB_SUBDIR=$(get_libdir)
	)
	cmake-utils_src_configure
}
