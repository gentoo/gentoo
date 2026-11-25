# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Development library for simulation games"
HOMEPAGE="https://www.flightgear.org/"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/flightgear/${PN}.git"
	EGIT_BRANCH="next"
else
	SRC_URI="https://gitlab.com/flightgear/simgear/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="cpu_flags_x86_sse2 ffmpeg gdal test"
RESTRICT="!test? ( test )"

# TODO AeonWave, CycloneDDS
RDEPEND="
	app-arch/xz-utils
	dev-libs/expat
	dev-games/openscenegraph
	media-libs/libglvnd[X]
	media-libs/openal
	net-dns/c-ares:=
	net-misc/curl
	virtual/zlib:=
	ffmpeg? ( media-video/ffmpeg:0= )
	gdal? ( >=sci-libs/gdal-3.10:= )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

PATCHES=(
	"${FILESDIR}"/0002-fix-support-for-aarch64.patch
	"${FILESDIR}"/${P}-fix_race_emesary.patch

	# https://gitlab.com/flightgear/simgear/-/work_items/56
	"${FILESDIR}"/${PN}-2024.1.7-fix_gdal.patch
)

src_configure() {
	# avoid -O3 -g
	CMAKE_BUILD_TYPE="Release"
	append-cppflags -DNDEBUG

	# maybe fixed by https://gitlab.com/flightgear/simgear/-/merge_requests/251
	append-cflags -std=gnu17 $(test-flags -Wno-deprecated-non-prototype)

	local mycmakeargs=(
		-DENABLE_ASAN=OFF
		-DENABLE_CYCLONE=OFF
		-DENABLE_GDAL=$(usex gdal)
		-DENABLE_PKGUTIL=ON
		-DENABLE_RTI=OFF
		-DENABLE_SIMD=$(usex cpu_flags_x86_sse2)
		-DENABLE_SOUND=ON
		-DENABLE_TESTS=$(usex test)
		-DENABLE_TSAN=OFF
		-DENABLE_VIDEO_RECORD=$(usex ffmpeg)
		-DSIMGEAR_HEADLESS=OFF
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_EXPAT=ON
		-DSYSTEM_UDNS=ON
		-DUSE_AEONWAVE=OFF
		-DUSE_OPENALSOFT=ON
		-DOSG_FSTREAM_EXPORT_FIXED=OFF # TODO perhaps track it
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# sandbox restriction (passed w/o portage)
		test_dns
		# maybe fixed w/ https://gitlab.com/flightgear/simgear/-/merge_requests/277
		test_http
	)

	# test_repository and catalog_test fail w/ parallel
	cmake_src_test -j1
}
