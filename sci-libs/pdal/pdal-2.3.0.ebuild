# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A C++ library for translating and manipulating point cloud data"
HOMEPAGE="https://pdal.io/"
SRC_URI="https://github.com/PDAL/PDAL/releases/download/${PV}/PDAL-${PV}-src.tar.gz"

LICENSE="BSD"
SLOT="0/13"
KEYWORDS="~amd64 ~x86"
IUSE="postgres"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/jsoncpp
	net-misc/curl
	sci-libs/gdal
	sci-libs/libgeotiff
	sci-geosciences/laszip
	sys-libs/libunwind
	sys-libs/zlib
	postgres? ( dev-db/postgresql:*[xml] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix_cmake_install_location.patch
	"${FILESDIR}"/${P}-upgrade_cmake_min.patch
)

S="${WORKDIR}/PDAL-${PV}-src"

src_configure() {
	local mycmakeargs=(
		-DBUILD_PLUGIN_PGPOINTCLOUD="$(usex postgres)"
		-DWITH_LAZPERF=OFF
		-DWITH_LASZIP=ON
		-DWITH_COMPLETION=ON
	)

	cmake_src_configure
}
