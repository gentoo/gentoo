# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Development library for simulation games"
HOMEPAGE="https://www.flightgear.org/"
SRC_URI="mirror://sourceforge/flightgear/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="cpu_flags_x86_sse2 +dns debug gdal openmp subversion test"
RESTRICT="!test? ( test )"

# TODO aeonwave
COMMON_DEPEND="
	app-arch/xz-utils
	dev-libs/expat
	dev-games/openscenegraph
	media-libs/openal
	net-misc/curl
	sys-libs/zlib
	virtual/opengl
	dns? ( net-libs/udns )
	gdal? ( sci-libs/gdal )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.44
"
RDEPEND="${COMMON_DEPEND}
	subversion? ( dev-vcs/subversion )
"

PATCHES=(
	"${FILESDIR}/${PN}-2019.1.1-gdal3.patch"
	"${FILESDIR}/${PN}-2020.1.2-do-not-assume-libc++-clang.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DNS=$(usex dns)
		-DENABLE_GDAL=$(usex gdal)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_PKGUTIL=ON
		-DENABLE_RTI=OFF
		-DENABLE_SIMD=$(usex cpu_flags_x86_sse2)
		-DENABLE_SOUND=ON
		-DENABLE_TESTS=$(usex test)
		-DSIMGEAR_HEADLESS=OFF
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_EXPAT=ON
		-DSYSTEM_UDNS=ON
		-DUSE_AEONWAVE=OFF
		-DOSG_FSTREAM_EXPORT_FIXED=OFF # TODO perhaps track it
	)
	cmake_src_configure
}
