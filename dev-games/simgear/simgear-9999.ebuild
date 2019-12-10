# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils toolchain-funcs flag-o-matic git-r3

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/flightgear/${PN}
	git://mapserver.flightgear.org/${PN}"
EGIT_BRANCH="next"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="cpu_flags_x86_sse2 +dns debug gdal openmp subversion test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/expat
	<dev-games/openscenegraph-3.5.6:=
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
		-DENABLE_SIMD=OFF # see CPU_FLAGS
		-DENABLE_SIMD_CODE=OFF
		-DENABLE_SOUND=ON
		-DENABLE_TESTS=$(usex test)
		-DSIMGEAR_HEADLESS=OFF
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_EXPAT=ON
		-DSYSTEM_UDNS=ON
		-DUSE_AEONWAVE=OFF
		-DOSG_FSTREAM_EXPORT_FIXED=OFF # TODO perhaps track it
	)

	if use cpu_flags_x86_sse2; then
		append-flags -msse2 -mfpmath=sse -ftree-vectorize -ftree-slp-vectorize
	fi

	cmake-utils_src_configure
}
