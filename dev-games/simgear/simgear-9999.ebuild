# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Development library for simulation games"
HOMEPAGE="https://www.flightgear.org/"
EGIT_REPO_URI="https://gitlab.com/flightgear/${PN}.git"
EGIT_BRANCH="next"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse2 debug ffmpeg gdal subversion test"
RESTRICT="!test? ( test )"

# TODO AeonWave, CycloneDDS
COMMON_DEPEND="
	dev-libs/expat
	dev-games/openscenegraph
	media-libs/openal
	net-libs/udns
	net-misc/curl
	sys-libs/zlib
	virtual/opengl
	ffmpeg? ( media-video/ffmpeg:0 )
	gdal? ( sci-libs/gdal:= )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	subversion? ( dev-vcs/subversion )
"

src_configure() {
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
