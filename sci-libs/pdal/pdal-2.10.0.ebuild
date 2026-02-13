# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ library for translating and manipulating point cloud data"
HOMEPAGE="https://pdal.io/"
SRC_URI="https://github.com/PDAL/PDAL/releases/download/${PV}/PDAL-${PV}-src.tar.bz2"
S="${WORKDIR}/PDAL-${PV}-src"

LICENSE="BSD"
SLOT="0/20"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug postgres test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	app-arch/zstd:=
	dev-libs/libxml2:=
	dev-libs/openssl:=
	net-misc/curl
	sci-libs/gdal:=
	>=sci-libs/libgeotiff-1.7.0:=
	virtual/zlib:=
	debug? ( sys-libs/libunwind:= )
	postgres? ( dev-db/postgresql:*[xml] )
"
DEPEND="
	${RDEPEND}
	test? ( sci-libs/gdal[geos,jpeg(+),png,sqlite] )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_PLUGIN_PGPOINTCLOUD="$(usex postgres)"
		-DWITH_COMPLETION=ON
		-DWITH_BACKTRACE="$(usex debug)"
		-DWITH_TESTS="$(usex test)"
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		--exclude-regex '(pgpointcloudtest|pdal_info_test|pdal_io_bpf_base_test|pdal_io_bpf_zlib_test|pdal_io_copc_reader_test|pdal_filters_overlay_test|pdal_filters_stats_test|pdal_app_plugin_test|pdal_merge_test|pdal_io_stac_reader_test)'
		--output-on-failure
		-j1
	)

	cmake_src_test
}
