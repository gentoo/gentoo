# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A C++ library for translating and manipulating point cloud data"
HOMEPAGE="https://pdal.io/"
SRC_URI="https://github.com/PDAL/PDAL/releases/download/${PV}/PDAL-${PV}-src.tar.bz2"

LICENSE="BSD"
SLOT="0/16"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="postgres test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	net-misc/curl
	app-arch/zstd:=
	dev-libs/libxml2
	dev-libs/openssl:=
	sci-libs/gdal:=
	sci-libs/libgeotiff:=
	sys-libs/zlib
	postgres? ( dev-db/postgresql:*[xml] )
"
# temporarily drop libunwind from RDEPEND and build w/o backtrace WRT https://github.com/PDAL/PDAL/issues/4211
#sys-libs/libunwind:=

DEPEND="
	test? ( sci-libs/gdal[geos,jpeg,png] )
	${RDEPEND}
"

S="${WORKDIR}/PDAL-${PV}-src"

src_configure() {
	local mycmakeargs=(
		-DBUILD_PLUGIN_PGPOINTCLOUD="$(usex postgres)"
		-DWITH_COMPLETION=ON
		-DWITH_BACKTRACE=OFF
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		--exclude-regex '(pgpointcloudtest|pdal_io_bpf_base_test|pdal_io_bpf_zlib_test|pdal_filters_overlay_test|pdal_filters_stats_test|pdal_app_plugin_test|pdal_merge_test|pdal_io_stac_reader_test)'
		--output-on-failure
		-j1
	)

	cmake_src_test
}
