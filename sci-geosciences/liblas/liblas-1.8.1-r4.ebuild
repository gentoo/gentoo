# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="C/C++ library for manipulating the LAS LiDAR format common in GIS"
HOMEPAGE="https://github.com/libLAS/libLAS/"
SRC_URI="https://github.com/libLAS/libLAS/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libLAS-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~x86"
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

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.0_remove-std-c++98.patch
	"${FILESDIR}"/${P}-fix-overload-call.patch # bug 661654
	"${FILESDIR}"/${P}-CVE-2018-20540.patch # bug 678482
	"${FILESDIR}"/${P}-CVE-2018-20540-fixup.patch # bug 698846
	"${FILESDIR}"/${P}-fix-debug.patch # bug 668778
	"${FILESDIR}"/${P}-boost-1.73.patch # bug 722878
	"${FILESDIR}"/${P}-gcc11.patch # bug 789732
	"${FILESDIR}"/${P}-c99.patch # bug 933089
)

src_prepare() {
	use gdal && has_version ">=sci-libs/gdal-2.5.0" && PATCHES+=(
		"${FILESDIR}"/${P}-gdal-2.5.0.patch # bug 707706
	)
	cmake_src_prepare

	# add missing linkage
	sed -e 's:${LAS2COL} ${LIBLAS_C_LIB_NAME}:& ${CMAKE_THREAD_LIBS_INIT}:' \
		-i "${S}/apps/CMakeLists.txt" || die
}

src_configure() {
	# Aliasing violations (bug #862585)
	filter-lto
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DLIBLAS_LIB_SUBDIR=$(get_libdir)
		-DWITH_GDAL=$(usex gdal)
	)
	cmake_src_configure
}
