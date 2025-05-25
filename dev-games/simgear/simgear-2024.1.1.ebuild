# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Development library for simulation games"
HOMEPAGE="https://www.flightgear.org/"
SRC_URI="https://gitlab.com/flightgear/fgmeta/-/jobs/9264813015/artifacts/raw/sgbuild/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 debug ffmpeg gdal subversion test"
RESTRICT="!test? ( test )"

# TODO AeonWave, CycloneDDS
COMMON_DEPEND="
	app-arch/xz-utils
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

PATCHES=(
	"${FILESDIR}/0001-check-to-be-sure-that-n-is-not-being-set-as-format-t.patch"
	"${FILESDIR}/0002-fix-support-for-aarch64.patch"
	"${FILESDIR}/${P}-boost.patch"
)

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
