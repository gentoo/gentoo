# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib multilib

DESCRIPTION="C/C++ library for manipulating the LAS LiDAR format common in GIS"
HOMEPAGE="http://www.liblas.org"
SRC_URI="http://download.osgeo.org/${PN}/libLAS-${PV}.tar.bz2"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="gdal geotiff"
REQUIRED_USE="gdal? ( geotiff )"

RDEPEND="
	dev-libs/boost:=
	sci-geosciences/laszip
	gdal? ( sci-libs/gdal )
	geotiff? ( sci-libs/libgeotiff )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libLAS-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}_remove-std-c++98.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package gdal GDAL)
		$(cmake-utils_use_find_package geotiff GeoTIFF)
		-DLIBLAS_LIB_SUBDIR=$(get_libdir)
	)
	cmake-utils_src_configure
}
