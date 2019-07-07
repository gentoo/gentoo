# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="C/C++ library for manipulating the LAS LiDAR format common in GIS"
HOMEPAGE="https://github.com/libLAS/libLAS/"
SRC_URI="https://github.com/libLAS/libLAS/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"
IUSE="gdal"

DEPEND="
	dev-libs/boost:=
	sci-geosciences/laszip
	sci-libs/libgeotiff:=
	gdal? ( sci-libs/gdal:= )
"
RDEPEND="${DEPEND}"

# tests known to fail due to LD_LIBRARY_PATH issue
RESTRICT="test"

S="${WORKDIR}/libLAS-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.0_remove-std-c++98.patch
	"${FILESDIR}"/${P}-fix-overload-call.patch # bug 661654
	"${FILESDIR}"/${P}-CVE-2018-20540.patch # bug 678482
)

src_prepare() {
	cmake-utils_src_prepare

	# add missing linkage
	sed -e 's:${LAS2COL} ${LIBLAS_C_LIB_NAME}:& ${CMAKE_THREAD_LIBS_INIT}:' \
		-i "${S}/apps/CMakeLists.txt" || die
}

src_configure() {
	local mycmakeargs=(
		-DLIBLAS_LIB_SUBDIR=$(get_libdir)
		-DWITH_GDAL=$(usex gdal)
	)
	cmake-utils_src_configure
}
